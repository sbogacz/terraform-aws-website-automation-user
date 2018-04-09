output "user_name" {
  description = "the IAM user's name"
  value       = "${aws_iam_user.automation_user.name}"
}

output "user_arn" {
  description = "the IAM user's ARN"
  value       = "${aws_iam_user.automation_user.arn}"
}
