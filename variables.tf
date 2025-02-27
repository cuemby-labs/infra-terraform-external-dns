#
# External DNS
#

variable "namespace_name" {
  description = "The namespace where resources will be created."
  type        = string
  default     = "external-dns"
}

variable "helm_release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "external-dns-cloudflare"
}

variable "helm_chart_version" {
  description = "The version of the Helm chart."
  type        = string
  default     = "8.3.7"
}

variable "policy" {
  description = "policy Modify how DNS records are synchronized between sources and providers."
  type        = string
  default     = "sync"
}

variable "resources" {
  type = map(map(string))
  default = {
    limits = {
      cpu    = "2000m"
      memory = "512Mi"
    }
    requests = {
      cpu    = "1000m"
      memory = "256Mi"
    }
  }
  description = "Resource limits and requests for the External-DNS Helm release."
}

variable "hpa_config" {
  description = "Configuration for the HPA targeting External-DNS Deployment"
  type        = object({
    min_replicas              = number
    max_replicas              = number
    target_cpu_utilization    = number
    target_memory_utilization = number
  })

  default = {
    min_replicas              = 1
    max_replicas              = 3
    target_cpu_utilization    = 80
    target_memory_utilization = 80
  }
}

#
# Cloudflare
#

variable "cloudflare_api_token" {
  description = "The Cloudflare API token, base64-encoded."
  type        = string
  sensitive   = true
}

variable "txt_owner_id" {
  description = "Cluster name for TXT owner ID."
  type        = string
}

#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}