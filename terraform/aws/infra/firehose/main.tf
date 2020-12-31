data "aws_elasticsearch_domain" "domain" {
  domain_name = var.es_domain_name
}

data "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"

  force_destroy = true
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "twitter_stream" {
  name              = "/aws/kinesisfirehose/${var.name}"
  retention_in_days = 0

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "s3_delivery" {
  name           = "S3Delivery"
  log_group_name = aws_cloudwatch_log_group.twitter_stream.name
}

resource "aws_cloudwatch_log_stream" "elasticsearch_delivery" {
  name           = "ElasticsearchDelivery"
  log_group_name = aws_cloudwatch_log_group.twitter_stream.name
}

resource "aws_kinesis_firehose_delivery_stream" "twitter_stream" {
  name        = var.name
  destination = "elasticsearch"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.bucket.arn
    buffer_size        = 3
    buffer_interval    = 180
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.name}"
      log_stream_name = "S3Delivery"
    }
  }

  elasticsearch_configuration {
    domain_arn = data.aws_elasticsearch_domain.domain.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = "comment"
    buffering_size = 1
    buffering_interval = 60

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${data.aws_lambda_function.lambda.arn}:$LATEST"
        }

        parameters {
          parameter_name  = "BufferSizeInMBs"
          parameter_value = "1"
        }

        # parameters {
        #   parameter_name  = "BufferIntervalInSeconds"
        #   parameter_value = "60"
        # }
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.name}"
      log_stream_name = "ElasticsearchDelivery"
    }
  }

  tags = var.tags
}