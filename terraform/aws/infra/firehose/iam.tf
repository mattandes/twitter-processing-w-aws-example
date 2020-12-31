data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose-twitter-processing-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

# https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html#using-iam-es
data "aws_iam_policy_document" "firehose_role" {
  statement {
    effect  = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "es:DescribeElasticsearchDomain",
      "es:DescribeElasticsearchDomains",
      "es:DescribeElasticsearchDomainConfig",
      "es:ESHttpPost",
      "es:ESHttpPut"
    ]

    resources = [
      data.aws_elasticsearch_domain.domain.arn,
      "${data.aws_elasticsearch_domain.domain.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "es:ESHttpGet"
    ]

    resources = [
      "${data.aws_elasticsearch_domain.domain.arn}/_all/_settings",
      "${data.aws_elasticsearch_domain.domain.arn}/_cluster/stats",
      "${data.aws_elasticsearch_domain.domain.arn}/comment*/_mapping/*",
      "${data.aws_elasticsearch_domain.domain.arn}/_nodes",
      "${data.aws_elasticsearch_domain.domain.arn}/_nodes/stats",
      "${data.aws_elasticsearch_domain.domain.arn}/_nodes/*/stats",
      "${data.aws_elasticsearch_domain.domain.arn}/_stats",
      "${data.aws_elasticsearch_domain.domain.arn}/comment*/_stats"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction", 
      "lambda:GetFunctionConfiguration"
    ]

    resources = [
      "${data.aws_lambda_function.lambda.arn}:*"
    ]
  }
}

resource "aws_iam_policy" "firehose_role" {
  name   = "${aws_iam_role.firehose_role.name}-policy"
  policy = data.aws_iam_policy_document.firehose_role.json
}

resource "aws_iam_role_policy_attachment" "firehose_role" {
  role      = aws_iam_role.firehose_role.name
  #policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  policy_arn = aws_iam_policy.firehose_role.arn
}
