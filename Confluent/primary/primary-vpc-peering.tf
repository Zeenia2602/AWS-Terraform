# For Source cluster
resource "confluent_network" "aws-source-peering" {
  display_name = "Source VPC Peering Network"
  cloud            = "AWS"
  connection_types = ["PEERING"]
  region           = var.source-region
  cidr = "192.168.0.0/16"
  environment {
    id = var.environement-id
  }
  aws {}
}

resource "confluent_peering" "aws-source" {
  display_name = "AWS Peering"
  aws {
    account         = "106039313224"
    customer_region = var.source-region
    routes = ["10.0.0.0/16"]
    vpc = "vpc-06fb07384264ca2ec"
  }
  environment {
    id = var.environement-id
  }
  network {
    id = confluent_network.aws-source-peering.id
  }

}
