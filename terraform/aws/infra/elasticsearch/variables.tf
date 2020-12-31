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

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "iam_role_arns" {
  default = []
  type = list(string)
}

variable "namespace" {
  default = "twit"
  description = "Namespace value used to generate domain name"
  type = string
}

variable "stage" {
  default = "dev"
  description = "Stage/Environment value used to generate domain name"
  type = string
}

variable "name" {
  default = "es"
  description = "Unique name to be used with other values to generate domain name"
  type = string
}

variable "elasticsearch_version" {
  default = "7.9"
  type = string
}

variable "instance_type" {
  default = "t3.small.elasticsearch"
  type = string
}

variable "instance_count" {
  default = 1
  type = number
}

variable "allowed_cidr_blocks" {
  default = ["0.0.0.0/0"]
  type = list(string)
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
