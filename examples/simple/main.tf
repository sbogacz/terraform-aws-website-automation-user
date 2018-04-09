provider "aws" {
  region = "us-east-1"
}

module "ci-user" {
  source      = "../../"
  domain      = "my-site.io"
  bucket_arns = ["my-bucket-ARN"]
}
