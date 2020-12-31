output "domain_name" {
  value       = module.elasticsearch.domain_name
  description = "Name of the Elasticsearch domain"
}

output "kibana_endpoint" {
  value       = module.elasticsearch.kibana_endpoint
  description = "Domain-specific endpoint for Kibana without https scheme"
}
