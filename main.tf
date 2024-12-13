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
# HPA
#

data "template_file" "hpa_manifest_template" {
  
  template = file("${path.module}/hpa.yaml.tpl")
  vars     = {
    namespace_name            = var.namespace_name,
    name_metadata             = "${helm_release.external_dns.name}",
    name_deployment           = "${helm_release.external_dns.name}"-cloudflare,
    min_replicas              = var.hpa_config.min_replicas,
    max_replicas              = var.hpa_config.max_replicas,
    target_cpu_utilization    = var.hpa_config.target_cpu_utilization,
    target_memory_utilization = var.hpa_config.target_memory_utilization
  }
}

data "kubectl_file_documents" "hpa_manifest_files" {

  content = data.template_file.hpa_manifest_template.rendered
}

resource "kubectl_manifest" "apply_manifests" {
  for_each  = data.kubectl_file_documents.hpa_manifest_files.manifests
  yaml_body = each.value
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
  depends_on = [kubernetes_secret.cloudflare_api_token]

  name       = var.helm_release_name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.helm_chart_version
  namespace  = var.namespace_name

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      request_memory = var.resources["requests"]["memory"],
      limits_memory  = var.resources["limits"]["memory"],
      request_cpu    = var.resources["requests"]["cpu"],
      limits_cpu     = var.resources["limits"]["cpu"]
    })
  ]

  set {
    name  = "txtOwnerId"
    value = var.txt_owner_id
  }

}

#
# Walrus information
#

locals {
  context = var.context
}