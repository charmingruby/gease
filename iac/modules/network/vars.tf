variable "tags" {
  description = "The tags to apply to all resources"
  type        = map(string)
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}
