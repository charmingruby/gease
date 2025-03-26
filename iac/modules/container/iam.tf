
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

resource "aws_iam_role" "container_role" {
  name = format("%s-container-role", var.tags["project"])

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
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
      },
      {
        "Sid" : "Statement2",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    "Name" = format("%s-container-role", var.tags["project"])
  })
}

resource "aws_iam_policy" "container_role_permission" {
  name = "container-permission"
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
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "container_role" {
  name   = "container-role-policy"
  role   = aws_iam_role.container_role.name
  policy = aws_iam_policy.container_role_permission.policy
}

resource "aws_iam_role_policy_attachment" "container_role_permission_attachment" {
  role       = aws_iam_role.container_role.name
  policy_arn = aws_iam_policy.container_role_permission.arn
}
