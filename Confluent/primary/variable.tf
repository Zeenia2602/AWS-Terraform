variable "source-region" {
}
variable "environement-id" {}
variable "confluent_cloud_api_key" {
  description = "Confluent Access key"
  type = string
  sensitive = true
}

variable "confluent_cloud_api_secret" {
  description = "Confluent secret key"
  type = string
  sensitive = true
}

variable "aws_access_key" {
  description = "AWS Login Access key"
  type = string
  sensitive = true
}

variable "aws_secret_key" {
  description = "AWS Secret key"
  type = string
  sensitive = true
}
