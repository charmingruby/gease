resource "aws_iam_role" "this" {
  name = format("%s_pipeline_role", var.tags["project"])
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = format("arn:aws:iam::%s:oidc-provider/token.actions.githubusercontent.com", data.aws_caller_identity.current_user.account_id)
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = format("repo:%s/%s:*", var.github_repository_owner, var.github_repository)
          }
        }
      }
    ]
  })

  inline_policy {
    name = "pipeline-app-permission"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ECR",
          "Action" : "ecr:*",
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" : "IAM",
          "Action" : "iam:*",
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" : "S3",
          "Action" : "s3:*",
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    })
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s_pipeline_role", var.tags["project"])
    }
  )
}
