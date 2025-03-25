
resource "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    var.oidc_thumbprint
  ]
  tags = merge(var.tags, {
    "Name" = "oidc-git-provider"
  })
}

resource "aws_iam_role" "ecr_role" {
  name = format("%s_ecr_role", var.tags["project"])

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        Principal = {
          Federated = format("arn:aws:iam::%s:oidc-provider/token.actions.githubusercontent.com", data.aws_caller_identity.current_user.account_id)
        }
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ],
            "token.actions.githubusercontent.com:sub" : [
              format("repo:%s/%s:ref:refs/heads/main", var.github_repository_owner, var.github_repository)
            ]
          }
        }
      }
    ]
  })

  inline_policy {
    name = "ecr-app-permission"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AllowPushPull",
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:UploadLayerPart",
            "ecr:InitiateLayerUpload",
            "ecr:CompleteLayerUpload",
            "ecr:PutImage",
            "ecr:BatchGetImage"
          ],
          "Resource" : "*"
        }
      ]
    })
  }

  tags = merge(var.tags, {
    "Name" = format("%s_ecr_role", var.tags["project"])
  })
}
