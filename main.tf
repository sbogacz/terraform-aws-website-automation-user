# this is the IAM user that will be used for automated deployments
# e.g. CircleCI, TravisCI, etc.
# NOTE: programmatic access keys will have to be created manually from the 
# AWS console
resource "aws_iam_user" "automation_user" {
  name = "${var.domain}_automation_user"
}

locals {
  bucket_paths = ["${formatlist("%s/*", var.bucket_arns)}"]
}

data "aws_iam_policy_document" "automation_user_policy" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = ["${var.bucket_arns}"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = ["${local.bucket_paths}"]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:ListDistributions",
      "cloudfront:GetDistribution",
    ]

    # CloudFront doesn't yet support resource level permissions
    resources = ["*"]
  }
}

resource "aws_iam_policy" "automation_user_policy" {
  name   = "${var.domain}_automation_user_policy"
  policy = "${data.aws_iam_policy_document.automation_user_policy.json}"
}

resource "aws_iam_user_policy_attachment" "automation_user_policy_attachment" {
  user       = "${aws_iam_user.automation_user.name}"
  policy_arn = "${aws_iam_policy.automation_user_policy.arn}"
}
