# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "state_bucket" {
  description = "The S3 bucket name used to store Terraform state so we can retrieve data from other parts of the infrastructure"
  type        = string
}

variable "lock_table" {
  description = "The DynamoDB table name used for locking of terraform state files"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
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
