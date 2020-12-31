locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

include {
  path = find_in_parent_folders()
}

dependency "lambda" {
  config_path = "../../apps/comprehend-lambda"
}

dependency "es" {
  config_path = "../elasticsearch"
}

inputs = {
  bucket_name = "${local.common_vars.inputs.account_id}-twitter-processing"
  es_domain_name = dependency.es.outputs.domain_name
  lambda_name = dependency.lambda.outputs.lambda_function_name
}
