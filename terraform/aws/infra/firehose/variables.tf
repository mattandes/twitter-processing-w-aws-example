# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_profile" {
  description = "AWS Profile that contains credentials to connect to AWS"
  type = string
  default = "default"
}

variable "region" {
  default = "us-east-2"
  type = string
}

variable "bucket_name" {
  description = "The S3 bucket to stored failed records"
  type = string
}

variable "lambda_name" {
  description = "The lambda name to be used when processing records"
  type = string
}

variable "es_domain_name" {
  description = "The Elasticsearch domain to send records to"
  type = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  default = "twitter-processing-example-stream"
  description = "The name of the Firehose stream to create"
  type = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
