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

resource "kubernetes_secret" "this" {
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

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "this" {
  name       = var.helm_release_name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.helm_chart_version
  namespace  = var.namespace_name

  values     = [file("${path.module}/values.yaml")]

  set {
    name  = "txtOwnerId"
    value = var.txt_owner_id
  }

  depends_on = [kubernetes_secret.cloudflare_api_token]
}