terraform {
  required_providers {
    confluent = {
      source = "confluentinc/confluent"
      version = "1.67.1"
    }
  }
}

provider "confluent" {
  cloud_api_key = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

# ---------------- Create kafka cluster ------------------
# Disaster Recovery Cluster
resource "confluent_kafka_cluster" "failover" {
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  display_name = "failover_cluster"
  region       = var.failover-region
  dedicated {
    cku = 1
  }
  network {
    id = confluent_network.aws-disaster-vpc-peering.id
  }
  environment {
    id = var.environment-id
  }
}








