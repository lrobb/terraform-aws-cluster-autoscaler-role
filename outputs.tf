output "role_arn" {
  description = "IAM role arn"
  value       = var.oidc_assume_role_arn != null ? aws_iam_role.aws_cluster_autoscaler[0].arn : null
}

output "policy_arn" {
  description = "IAM policy arn"
  value       = aws_iam_policy.aws_cluster_autoscaler.arn
}
