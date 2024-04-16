variable "region" {
}
# Login into AWS account
variable "aws_access_key" {
  description = "AWS Login access key"
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  description = "AWS Login secret key"
  type        = string
  sensitive   = true
}

variable "PRIVATE_KEY" {
}
variable "PUBLIC_KEY" {
}

variable "USER_DATA" {}