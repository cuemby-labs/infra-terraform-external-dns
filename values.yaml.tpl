# CloudFlare Configuration
provider: cloudflare
cloudflare:
  secretName: cloudflare-api-token
# External_DNS Pod resources
resources:
  limits:
    cpu: ${limits_cpu}
    memory: ${limits_memory}
  requests:
    cpu: ${request_cpu}
    memory: ${request_memory}