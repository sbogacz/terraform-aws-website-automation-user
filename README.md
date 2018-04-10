# aws-website-automation-user

This module is used to create automation users (think, CI/CD users, e.g. CircleCI, TravisCI, BuildKite, etc.). It can be used independently, or in conjunction with the [terraform-website module](https://github.com/sbogacz/terraform-website) module.

## Resources Created

This module creates an [IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html), an [IAM Policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) with S3 (ListBucket, GetObject,PutObject) and CloudFront (ListDistribution, GetDistribution, and CreateInvalidation) permissions, and [attaches them to the crated user](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html).

## Outputs

This module outputs the IAM user name and ARN.

## Programmatic Access Keys

To use this IAM user effectively, you're going to want to manually go into the console and generate an access and secret access key pair for the user. This module does not create those for you, because that would result in secrets (the keys) existing in the `tfstate` file. It is generally a better practice to create these out of band from the automation, to avoid accidentally leaking AWS credentials

## Example
```hcl
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
```
