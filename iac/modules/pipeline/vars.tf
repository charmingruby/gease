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


