resource "null_resource" "dependencies" {
  triggers = var.dependency_ids
}

resource "random_password" "minio_root_secretkey" {
  length  = 16
  special = false
}

locals {
  oidc_needs_custom_ca = var.oidc != null && var.cluster_issuer != "letsencrypt-prod"
}

data "kubernetes_secret_v1" "oidc_ca_source" {
  count = local.oidc_needs_custom_ca ? 1 : 0

  metadata {
    name      = var.oidc_ca_source_secret_name
    namespace = var.oidc_ca_source_secret_namespace
  }
}

resource "kubernetes_secret_v1" "oidc_ca" {
  count = local.oidc_needs_custom_ca ? 1 : 0

  metadata {
    name      = var.oidc_ca_secret_name
    namespace = "minio"
  }

  data = {
    "ca.crt" = data.kubernetes_secret_v1.oidc_ca_source[0].data["tls.crt"]
  }
}

resource "argocd_project" "this" {
  count = var.argocd_project == null ? 1 : 0

  metadata {
    name      = var.destination_cluster != "in-cluster" ? "minio-${var.destination_cluster}" : "minio"
    namespace = "argocd"
  }

  spec {
    description  = "MinIO application project for cluster ${var.destination_cluster}"
    source_repos = ["https://github.com/GersonRS/modern-gitops-stack-module-minio.git"]

    destination {
      name      = var.destination_cluster
      namespace = "minio"
    }

    orphaned_resources {
      warn = true
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

data "utils_deep_merge_yaml" "values" {
  input = [for i in concat(local.helm_values, var.helm_values) : yamlencode(i)]
}

resource "argocd_application" "this" {
  metadata {
    name      = var.destination_cluster != "in-cluster" ? "minio-${var.destination_cluster}" : "minio"
    namespace = "argocd"
    labels = merge({
      "application" = "minio"
      "cluster"     = var.destination_cluster
    }, var.argocd_labels)
  }

  timeouts {
    create = "15m"
    delete = "15m"
  }

  wait = var.app_autosync == { "allow_empty" = tobool(null), "prune" = tobool(null), "self_heal" = tobool(null) } ? false : true

  spec {
    project = var.argocd_project == null ? argocd_project.this[0].metadata.0.name : var.argocd_project

    source {
      repo_url        = "https://github.com/GersonRS/modern-gitops-stack-module-minio.git"
      path            = "charts/minio"
      target_revision = var.target_revision
      helm {
        release_name = "minio"
        values       = data.utils_deep_merge_yaml.values.output
      }
    }

    destination {
      name      = var.destination_cluster
      namespace = "minio"
    }

    sync_policy {
      dynamic "automated" {
        for_each = toset(var.app_autosync == { "allow_empty" = tobool(null), "prune" = tobool(null), "self_heal" = tobool(null) } ? [] : [var.app_autosync])
        content {
          prune       = automated.value.prune
          self_heal   = automated.value.self_heal
          allow_empty = automated.value.allow_empty
        }
      }

      retry {
        backoff {
          duration     = "20s"
          max_duration = "2m"
          factor       = "2"
        }
        limit = "5"
      }

      sync_options = [
        "CreateNamespace=true"
      ]
    }
  }

  depends_on = [
    resource.null_resource.dependencies,
    resource.kubernetes_secret_v1.oidc_ca,
  ]
}

resource "null_resource" "this" {
  depends_on = [
    resource.argocd_application.this,
  ]
}
