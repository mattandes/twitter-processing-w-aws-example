module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "comprehend-lambda"
  description   = "Function to run Tweets through Amazon comprehend"
  handler       = "comprehend-lambda.lambda_handler"
  runtime       = "python3.8"
  timeout       = "120"

  source_path = "../../../../apps/comprehend-lambda"

  attach_policies = true
  number_of_policies = 1
  policies = [
    "arn:aws:iam::aws:policy/ComprehendFullAccess"
  ]

  tags = merge(
    {
      Name = "comprehend-lambda"
    },
    var.tags
  )
}