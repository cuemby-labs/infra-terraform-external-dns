locals {
  context = var.context
}

module "submodule" {
  source = "./modules/submodule"

  message = "Hello, submodule"
}

#
# Cloudflare 
#

resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = var.namespace_name
  }

  data = {
    cloudflare_api_token = var.cloudflare_api_token
  }
}

#
# External DNS 
#

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "external_dns" {
  name       = var.helm_release_name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.helm_chart_version
  namespace  = var.namespace_name

  # values     = [file("${path.module}/values.yaml")]

  set {
    name  = "provider"
    value = "cloudflare"
  }

  set {
    name  = "cloudflare.secretName"
    value = "cloudflare-api-token"
  }

  set {
    name  = "resources.requests.cpu"
    value = "1000m"
  }

  set {
    name  = "resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "2000m"
  }

  set {
    name  = "resources.limits.memory"
    value = "512Mi"
  }

  depends_on = [kubernetes_secret.cloudflare_api_token]
}