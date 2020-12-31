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
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
