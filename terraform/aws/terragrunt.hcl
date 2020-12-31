locals {
  account_id = "${get_aws_account_id()}"
  region = get_env("AWS_DEFAULT_REGION", "us-east-2")
  aws_profile = get_env("AWS_PROFILE", "default")
  state_bucket = "${local.account_id}-twit-tfstate"
  lock_table = "${local.account_id}-twit-tflocks"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = local.state_bucket
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = local.region
    dynamodb_table = local.lock_table
    encrypt = true
    skip_bucket_root_access = true
    skip_bucket_accesslogging = true
  }
}

inputs = {
  account_id = local.account_id
  state_bucket = local.state_bucket
  lock_table = local.lock_table
  aws_profile = local.aws_profile
  tags = {
    Terraform = "true"
    Project = "twitter-processing-example"
  }
}

terraform {
  extra_arguments "plugin_cache_dir" {
    commands = ["init"]
    env_vars = {
      TF_PLUGIN_CACHE_DIR = "${get_parent_terragrunt_dir()}/.terraform.d/plugin-cache"
    }
  }
}