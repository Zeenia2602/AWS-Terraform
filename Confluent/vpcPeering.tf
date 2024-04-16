## For Source cluster
#resource "confluent_network" "aws-source-peering" {
#  display_name = "Source VPC Peering Network"
#  cloud            = "AWS"
#  connection_types = ["PEERING"]
#  region           = var.region
#  cidr = "192.168.0.0/16"
#  environment {
#    id = confluent_environment.AWS_terraform.id
#  }
#
#}
#
#resource "confluent_peering" "aws-source" {
#  display_name = "AWS Peering"
#  aws {
#    account         = "106039313224"
#    customer_region = "us-east-1"
#    routes = ["10.0.0.0/16"]
#    vpc = "vpc-03d135978f80c46e2"
#  }
#  environment {
#    id = confluent_environment.AWS_terraform.id
#  }
#  network {
#    id = confluent_network.aws-source-peering.id
#  }
#
#}
#
## For Disaster Recovery
#resource "confluent_network" "aws-disaster-vpc-peering" {
#  display_name = "AWS Disaster Recovery VPC Peering"
#  cloud            = "AWS"
#  connection_types = ["PEERING"]
#  region           = var.failover-region
#  cidr = "192.168.0.0/16"
#  environment {
#    id = confluent_environment.AWS_terraform.id
#  }
#
#}
#
#resource "confluent_peering" "aws-disaster-recovery" {
#  display_name = "AWS Disaster Recovery Peering"
#  aws {
#    account         = "106039313224"
#    customer_region = "us-east-2"
#    routes          = ["10.2.0.0/16"]
#    vpc             = "vpc-0c3217ffba6025b30"
#  }
#
#  environment {
#    id = confluent_environment.AWS_terraform.id
#  }
#  network {
#    id = confluent_network.aws-disaster-vpc-peering.id
#  }
#}
#
