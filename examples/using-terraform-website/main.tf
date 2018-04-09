provider "aws" {
  region = "us-east-1"
}

locals {
  domain = "my-site.io"
}

module "my-site" {
  source = "terraform-website"

  tags = {
    website = "${local.domain}"
    use     = "personal"
  }

  domain                           = "${local.domain}"
  http_method_configuration        = "read-and-options"
  cached_http_method_configuration = "read-and-options"

  acm_certificate_arn = "arn:aws:acm:us-east-1:<account-id>:certificate/<certificate-id>"
}

module "ci-user" {
  source      = "../../"
  domain      = "${local.domain}"
  bucket_arns = ["${module.my-site.bucket_arn}"]
}
