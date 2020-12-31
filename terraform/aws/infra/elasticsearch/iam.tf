data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "elasticsearch-admin" {
  name = "elasticsearch-twitter-processing-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}