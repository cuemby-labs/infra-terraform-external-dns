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