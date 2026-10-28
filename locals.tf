locals {
  domain = "minio.${var.subdomain != "" ? "${trimprefix(var.subdomain, ".")}." : ""}${var.base_domain}"

  api_domain = "minio-api.${var.subdomain != "" ? "${trimprefix(var.subdomain, ".")}." : ""}${var.base_domain}"

  # The upstream MinIO images (quay.io/minio/*) are no longer publicly
  # pullable (HTTP 401) and the release binaries at dl.min.io are gone
  # (HTTP 410). This module therefore runs images built from the upstream
  # source at a pinned tag.
  #
  # The tag is pinned to RELEASE.2025-04-22T22-12-26Z because it is the last
  # release that embeds MinIO Console v1.7.6, which still ships the OIDC/SSO
  # login. Releases from 2025-05-24 onward embed Console v1.7.7, which removed
  # the SSO login from the OSS web UI (the login strategy is hardcoded to
  # "form" and the /api/v1/login/oauth2/auth route no longer exists).
  #
  # Build recipe (AGPLv3 source): https://github.com/minio/minio and
  # https://github.com/minio/mc. See the README for the Dockerfile.
  images = {
    image = {
      repository = "gersonrs/minio"
      tag        = "2025.4.22"
      pullPolicy = "IfNotPresent"
    }
    mcImage = {
      repository = "gersonrs/mc"
      tag        = "2024.11.21"
      pullPolicy = "IfNotPresent"
    }
  }

  # MinIO reads the OIDC provider configuration from MINIO_IDENTITY_OPENID_*
  # environment variables. `trustedCertsSecret` makes the server trust the
  # cert-manager CA that signs the OIDC provider (Keycloak) certificate, so the
  # HTTPS discovery document can be fetched.
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
    displayName  = "SSO"
  } : null

  # Map the module contract (config_minio) to the upstream chart provisioning
  # sections: `policies`, `users` and `buckets`.
  provisioning_config = {
    policies = [for p in var.config_minio.policies : {
      name = p.name
      statements = [for s in p.statements : {
        resources = s.resources
        actions   = s.actions
        effect    = "Allow"
      }]
    }]
    users = [for u in var.config_minio.users : {
      accessKey = u.accessKey
      secretKey = u.secretKey
      policy    = u.policy
    }]
    buckets = [for b in var.config_minio.buckets : {
      name   = b.name
      policy = b.policy
      purge  = false
    }]
  }

  helm_values = [{
    minio = merge(
      local.images,
      {
        mode          = var.mode ## other supported values are standalone or distributed
        replicas      = var.replicas
        drivesPerNode = 2
        persistence = {
          enabled = true
          size    = "${var.persistence_size}Gi"
        }
        resources = {
          requests = {
            memory = "128Mi"
          }
        }
        rootUser     = "root"
        rootPassword = random_password.minio_root_secretkey.result
        # The web UI (Console) is embedded in the MinIO server. It is the only
        # surface that renders the OIDC/SSO login button, so it is served on the
        # console port and exposed through the console service/HTTPRoute.
        consoleService = {
          type = "ClusterIP"
          port = "9090"
        }
        minioConsolePort = "9090"
        oidc             = local.oidc_config
        environment      = local.oidc_config != null ? { MINIO_BROWSER = "on" } : {}
        # The chart mounts `trustedCertsSecret` under certsPath and MinIO trusts
        # every CA bundle found there for outbound HTTPS (OIDC discovery).
        trustedCertsSecret = local.oidc_config != null && var.cluster_issuer != "letsencrypt-prod" ? "minio-tls" : ""
        service = {
          type = "ClusterIP"
          port = "9000"
        }
        httproute = {
          enabled           = true
          host              = local.domain
          api_host          = local.api_domain
          gateway_name      = var.gateway_name
          gateway_namespace = var.gateway_namespace
        }
        metrics = {
          enabled = var.enable_service_monitor
          serviceMonitor = {
            enabled       = var.enable_service_monitor
            interval      = "30s"
            scrapeTimeout = "10s"
          }
        }
        policies = local.provisioning_config.policies
        users    = local.provisioning_config.users
        buckets  = local.provisioning_config.buckets
      }
    )
  }]
}
