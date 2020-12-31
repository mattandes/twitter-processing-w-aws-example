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

variable "twitter_access_token" {
  description = "Twitter access token to access streaming API"
  type        = string
}

variable "twitter_access_token_secret" {
  description = "Twitter access token secret to access streaming API"
  type        = string
}

variable "twitter_consumer_key" {
  description = "Twitter consumer key to access streaming API"
  type        = string
}

variable "twitter_consumer_secret" {
  description = "Twitter consumer secret to access streaming API"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "role_name" {
  description = "The name of the role to start the EC2 instance with that has permissions to required AWS resources"
  type        = string
  default     = "twitter-processing-example-role"
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
