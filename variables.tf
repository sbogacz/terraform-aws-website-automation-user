variable "domain" {
  type        = "string"
  description = "the domain name of the website that the automation user will be maintaining. This is only to add detail to the resources"
}

variable "bucket_arns" {
  type        = "list"
  description = "a list of the S3 bucket ARNs that you'd like the automation user to have access to"
}
