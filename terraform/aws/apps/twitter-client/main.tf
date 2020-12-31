resource "aws_ssm_parameter" "twitter_access_token" {
  name        = "/twitter-processing-example/twitter_access_token"
  description = "Twitter access token"
  type        = "SecureString"
  value       = var.twitter_access_token

  tags = var.tags
}

resource "aws_ssm_parameter" "twitter_access_token_secret" {
  name        = "/twitter-processing-example/twitter_access_token_secret"
  description = "Twitter access token secret"
  type        = "SecureString"
  value       = var.twitter_access_token_secret

  tags = var.tags
}

resource "aws_ssm_parameter" "twitter_consumer_key" {
  name        = "/twitter-processing-example/twitter_consumer_key"
  description = "Twitter consumer key"
  type        = "SecureString"
  value       = var.twitter_consumer_key

  tags = var.tags
}

resource "aws_ssm_parameter" "twitter_consumer_secret" {
  name        = "/twitter-processing-example/twitter_consumer_secret"
  description = "Twitter consumer secret"
  type        = "SecureString"
  value       = var.twitter_consumer_secret

  tags = var.tags
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "twitter-client"
  description   = "Function to run Twitter client to ingest Tweets"
  handler       = "twitter-client-lambda.lambda_handler"
  runtime       = "python3.7"
  timeout       = "120"

  source_path = "../../../../apps/twitter-client"

  attach_policies = true
  number_of_policies = 2
  policies = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
  ]

  tags = merge(
    {
      Name = "twitter-client"
    },
    var.tags
  )
}