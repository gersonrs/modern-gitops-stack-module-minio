locals {
  domain = "minio.${var.subdomain != "" ? "${trimprefix(var.subdomain, ".")}." : ""}${var.base_domain}"

  api_domain = "minio-api.${var.subdomain != "" ? "${trimprefix(var.subdomain, ".")}." : ""}${var.base_domain}"

  # The Bitnami chart runs the MinIO server as non-root (UID 1001). The
  # volumePermissions init container fixes the PV ownership so the server can
  # write to it (needed e.g. with the Rancher local-path provisioner).
  init_volume_permissions = {
    defaultInitContainers = {
      volumePermissions = {
        enabled = true
        image = {
          registry   = "docker.io"
          repository = "bitnamilegacy/os-shell"
          tag        = "12-debian-12-r50"
        }
      }
    }
  }

  # The upstream Bitnami images (docker.io/bitnami/*) are no longer served
  # publicly (404). The `bitnamilegacy` mirror hosts the same Bitnami builds
  # and is currently the only reachable source of the MinIO server, client and
  # console images.
  images = {
    image = {
      registry   = "docker.io"
      repository = "bitnamilegacy/minio"
      tag        = "2025.7.23-debian-12-r3"
    }
    clientImage = {
      registry   = "docker.io"
      repository = "bitnamilegacy/minio-client"
      tag        = "2025.7.21-debian-12-r2"
    }
  }

  self_signed_cert = {
    extraVolumeMounts = [
      {
        name      = "certificate"
        mountPath = format("/etc/ssl/certs/%s", var.cluster_issuer == "letsencrypt-staging" ? "tls.crt" : "ca.crt")
        subPath   = var.cluster_issuer == "letsencrypt-staging" ? "tls.crt" : "ca.crt"
      },
    ]
    extraVolumes = [
      {
        name = "certificate"
        secret = {
          secretName = "minio-tls"
        }
      }
    ]
  }

  # The Bitnami chart has no native OIDC section. The MinIO server reads OIDC
  # configuration from environment variables, so we expose the same
  # MINIO_IDENTITY_OPENID_* environment variables the previous chart generated.
  oidc_config = var.oidc != null ? {
    enabled      = true
    configUrl    = "${var.oidc.issuer_url}/.well-known/openid-configuration"
    clientId     = var.oidc.client_id
    clientSecret = var.oidc.client_secret
    claimName    = "policy"
    scopes       = "openid,profile,email"
    redirectUri  = format("%s://%s/oauth_callback", split("://", var.oidc.issuer_url)[0], local.domain)
    claimPrefix  = ""
    comment      = ""
  } : null

  oidc_env_vars = local.oidc_config != null ? [
    {
      name  = "MINIO_IDENTITY_OPENID_CONFIG_URL"
      value = local.oidc_config.configUrl
    },
    {
      name  = "MINIO_IDENTITY_OPENID_CLIENT_ID"
      value = local.oidc_config.clientId
    },
    {
      name  = "MINIO_IDENTITY_OPENID_CLIENT_SECRET"
      value = local.oidc_config.clientSecret
    },
    {
      name  = "MINIO_IDENTITY_OPENID_CLAIM_NAME"
      value = local.oidc_config.claimName
    },
    {
      name  = "MINIO_IDENTITY_OPENID_CLAIM_PREFIX"
      value = local.oidc_config.claimPrefix
    },
    {
      name  = "MINIO_IDENTITY_OPENID_SCOPES"
      value = local.oidc_config.scopes
    },
    {
      name  = "MINIO_IDENTITY_OPENID_COMMENT"
      value = local.oidc_config.comment
    },
    {
      name  = "MINIO_IDENTITY_OPENID_REDIRECT_URI"
      value = local.oidc_config.redirectUri
    },
  ] : []

  # Map the module contract (config_minio) to the Bitnami provisioning section.
  # - Policies default to Effect "Allow" (the Bitnami job defaults to "Deny").
  # - Bucket `purge` has no equivalent in Bitnami and is intentionally ignored.
  # - Bucket anonymous `policy` is applied via extraCommands (alias `provisioning`).
  provisioning_config = {
    enabled = true
    policies = [for p in var.config_minio.policies : {
      name = p.name
      statements = [for s in p.statements : {
        resources = s.resources
        actions   = s.actions
        effect    = "Allow"
      }]
    }]
    users = [for u in var.config_minio.users : {
      username    = u.accessKey
      password    = u.secretKey
      policies    = [u.policy]
      setPolicies = true
    }]
    buckets = [for b in var.config_minio.buckets : {
      name       = b.name
      versioning = b.versioning != null ? b.versioning : false
      withLock   = b.objectlocking != null ? b.objectlocking : false
    }]
    extraCommands = [
      for b in var.config_minio.buckets : "mc anonymous set ${b.policy != null ? b.policy : "none"} provisioning/${b.name}" if b.policy != null && b.policy != "none"
    ]
  }

  helm_values = [{
    minio = merge(
      local.images,
      local.init_volume_permissions,
      {
        mode = var.mode ## other supported values are standalone or distributed
        statefulset = {
          zones         = 2
          replicaCount  = var.replicas
          drivesPerNode = 2
        }
        persistence = {
          size = "${var.persistence_size}Gi"
        }
        resources = {
          requests = {
            memory = "128Mi"
          }
        }
        auth = {
          rootUser     = "root"
          rootPassword = random_password.minio_root_secretkey.result
        }
        console = {
          image = {
            registry   = "docker.io"
            repository = "bitnamilegacy/minio-object-browser"
            tag        = "2.0.2-debian-12-r3"
          }
          ingress = {
            enabled = false
          }
          service = {
            ports = {
              http = 9090
            }
          }
        }
        httproute = {
          enabled           = true
          host              = local.domain
          api_host          = local.api_domain
          gateway_name      = var.gateway_name
          gateway_namespace = var.gateway_namespace
        }
        metrics = {
          enabled            = var.enable_service_monitor
          prometheusAuthType = "public"
          serviceMonitor = {
            enabled       = var.enable_service_monitor
            interval      = "30s"
            scrapeTimeout = "10s"
          }
        }
        provisioning   = local.provisioning_config
        extraEnvVars   = local.oidc_env_vars
        cluster_issuer = var.cluster_issuer
      },
      local.oidc_config != null && var.cluster_issuer != "letsencrypt-prod" ? {
        extraVolumeMounts = local.self_signed_cert.extraVolumeMounts
        extraVolumes      = local.self_signed_cert.extraVolumes
      } : null
    )
  }]
}
