# For Disaster Recovery
resource "confluent_network" "aws-disaster-vpc-peering" {
  display_name = "AWS Disaster Recovery VPC Peering"
  cloud            = "AWS"
  connection_types = ["PEERING"]
  region           = var.failover-region
  cidr = "192.168.0.0/16"
  environment {
    id = var.environment-id
  }
  aws {}
}

resource "confluent_peering" "aws-disaster-recovery" {
  display_name = "AWS Disaster Recovery Peering"
  aws {
    account         = "106039313224"
    customer_region = "us-east-2"
    routes          = ["10.2.0.0/16"]
    vpc             = "vpc-0dd62df2c3058f7d0"
  }

  environment {
    id = var.environment-id
  }
  network {
    id = confluent_network.aws-disaster-vpc-peering.id
  }
}

