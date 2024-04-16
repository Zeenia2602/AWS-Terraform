
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

# Source Cluster
resource "confluent_kafka_cluster" "source" {
  cloud        = "AWS"
  display_name = "kafka_source_cluster"
  region       = var.source-region
  availability = "SINGLE_ZONE"
  dedicated {
    cku = 1
  }
  network {
    id = confluent_network.aws-source-peering.id
  }
  environment {
    id = var.environement-id
  }
}









