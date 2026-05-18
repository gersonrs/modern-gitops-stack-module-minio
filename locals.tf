locals {
  domain = "minio.${var.subdomain != "" ? "${trimprefix(var.subdomain, ".")}." : ""}${var.base_domain}"

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

  oidc_config = var.oidc != null ? merge(
    {
      oidc = {
        enabled      = true
        configUrl    = "${var.oidc.issuer_url}/.well-known/openid-configuration"
        clientId     = var.oidc.client_id
        clientSecret = var.oidc.client_secret
        claimName    = "policy"
        scopes       = "openid,profile,email"
        redirectUri  = format("%s://%s/oauth_callback", split("://", var.oidc.issuer_url)[0], local.domain)
        claimPrefix  = ""
        comment      = ""
      }
    },
    var.cluster_issuer != "letsencrypt-prod" ? local.self_signed_cert : null
  ) : null

  helm_values = [{
    minio = merge(
      {
        mode          = var.mode ## other supported values are standalone or distributed
        drivesPerNode = 2
        replicas      = var.replicas
        pools         = 2
        persistence = {
          size = "${var.persistence_size}Gi"
        }
        resources = {
          requests = {
            memory = "128Mi"
          }
        }
        consoleIngress = {
          enabled = false
        }
        httproute = {
          enabled           = true
          host              = local.domain
          gateway_name      = var.gateway_name
          gateway_namespace = var.gateway_namespace
        }
        metrics = {
          serviceMonitor = {
            enabled       = var.enable_service_monitor
            includeNode   = true
            interval      = "30s"
            scrapeTimeout = "10s"
            public        = true
          }
        }
        rootUser       = "root"
        rootPassword   = random_password.minio_root_secretkey.result
        users          = var.config_minio.users
        buckets        = var.config_minio.buckets
        policies       = var.config_minio.policies
        cluster_issuer = var.cluster_issuer
      },
      local.oidc_config
    )
  }]
}
