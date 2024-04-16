variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key"
  type = string
  sensitive = true
}
variable "confluent_cloud_api_secret" {
  description = "Conluent Cloud API Secret"
  type = string
  sensitive = true
}

variable "region" {
  description = "The region of Confluent Cloud Network"
  type = string
}
variable "failover-region" {
  description = "The region of Disaster Recovery Confluent Cloud Kafka cluster"
  type = string
}
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
##variable "cidr" {
#  description = "The CIDR of confluent Cloud Network"
#  type = string
#}
#variable "disaster-recovery-cidr" {
#  description = "The CIDR for disaster recovery cluster"
#  type = string
#}
#
#variable "aws_account_id" {
#  description = "The AWS accound ID of the peer VPC owner"
#  type = string
#}
#
#variable "vpc_id" {
#  description = "The AWS VPC ID of the peer VPC"
#  type = string
#}
#variable "disaster-recovery-vpc-id" {
#  description = "The AWS VPC ID of the Disaster recovery "
#  type = string
#}
#
#variable "routes" {
#  description = "The AWS VPC CIDR blocks or subnets. Must not overlap with Confluent CIDR block"
#  type = list(string)
#}
#variable "disaster-recovery-routes" {
#  description = "The AWS VPC CIDR blocks or subnets of disaster recovery"
#  type = list(string)
#}
#
#variable "customer_region" {
#  description = "The region of the AWS peer VPC "
#  type = string
#}
#variable "disaster-recovery-customer-region" {
#  description = "The disaster recovery region of the AWS peer VPC"
#  type = string
#}

