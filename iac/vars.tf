variable "project" {
  description = "The project name"
  type        = string
}

variable "department" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "The project name"
  type        = string
  default     = "dev"
}

variable "managed_by" {
  description = "The project name"
  type        = string
  default     = "Terraform"
}

variable "created_at" {
  description = "The project name"
  type        = string
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

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}
