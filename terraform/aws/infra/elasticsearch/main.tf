module "elasticsearch" {
  source = "cloudposse/elasticsearch/aws"

  namespace               = var.namespace
  stage                   = var.stage
  name                    = var.name
  domain_hostname_enabled = false
  vpc_enabled             = false
  zone_awareness_enabled  = "false"
  availability_zone_count = 1
  elasticsearch_version   = var.elasticsearch_version
  instance_type           = var.instance_type
  instance_count          = var.instance_count
  ebs_volume_size         = 10
  iam_role_arns           = concat(var.iam_role_arns, [aws_iam_role.elasticsearch-admin.arn])
  iam_actions             = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  allowed_cidr_blocks     = var.allowed_cidr_blocks
  encrypt_at_rest_enabled = true
  kibana_hostname_enabled = false
  kibana_subdomain_name   = "kibana-es"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = var.tags
}
