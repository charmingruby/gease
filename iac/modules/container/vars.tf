variable "tags" {
  description = "The tags to apply to all resources"
  type        = map(string)
}

variable "github_repository" {
  description = "The GitHub repository to use"
  type        = string
}

variable "github_repository_owner" {
  description = "The GitHub repository owner"
  type        = string
}

variable "oidc_thumbprint" {
  description = "The OIDC thumbprint"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
