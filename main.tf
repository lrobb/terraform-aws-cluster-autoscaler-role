resource "aws_iam_policy" "aws_cluster_autoscaler" {
  name        = var.policy_name
  path        = "/"
  description = "Allows access to resources needed to run kubernetes cluster autoscaler."

  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}

resource "aws_iam_role" "aws_cluster_autoscaler" {
  count = var.ec2_role_name == null ? 1 : 0

  name = var.role_name
  path = "/"

  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.oidc_assume_role_arn}"
      }
    }
  ]
}
JSON
}

resource "aws_iam_role_policy_attachment" "aws_cluster_autoscaler" {
  policy_arn = aws_iam_policy.aws_cluster_autoscaler.arn
  role       = var.ec2_role_name == null ? aws_iam_role.aws_cluster_autoscaler[0].name : var.ec2_role_name
}
