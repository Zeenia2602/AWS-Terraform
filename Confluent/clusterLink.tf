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

# Creating the environment on Confluent cloud
resource "confluent_environment" "AWS_terraform" {
  display_name = "AWS_terraform"
}


module "primary" {
  source = "./primary"
  source-region = "us-east-1"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  environement-id = confluent_environment.AWS_terraform.id
}

module "failover" {
  source = "./failover"
  failover-region = "us-east-2"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  confluent_cloud_api_key = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
  environment-id = confluent_environment.AWS_terraform.id
}



resource "confluent_cluster_link" "source-jumpOver" {
  link_name = "jump-link"
  link_mode = "SOURCE"
  connection_mode = "OUTBOUND"
  source_kafka_cluster {
    id = module.primary.kafka_cluster_id
    rest_endpoint = module.primary.kafka_cluster_rest_endpoint
    credentials {
      key    = module.primary.kafka_cluster_api_key_id
      secret = module.primary.kafka_cluster_api_secret_key
    }
  }
  destination_kafka_cluster {
    id = confluent_kafka_cluster.jump-over.id
    bootstrap_endpoint = confluent_kafka_cluster.jump-over.bootstrap_endpoint
    credentials {
      key    = confluent_api_key.jump-api-key.id
      secret = confluent_api_key.jump-api-key.secret
    }
  }
  depends_on = [
    confluent_cluster_link.jump-source
  ]
}

resource "confluent_cluster_link" "jump-source" {
  link_name = "jump-link"
  link_mode = "DESTINATION"
  connection_mode = "INBOUND"
  destination_kafka_cluster {
    id = confluent_kafka_cluster.jump-over.id
    rest_endpoint = confluent_kafka_cluster.jump-over.rest_endpoint
    credentials {
      key    = confluent_api_key.jump-api-key.id
      secret = confluent_api_key.jump-api-key.secret
    }
  }
  source_kafka_cluster {
    id = module.primary.kafka_cluster_id
    bootstrap_endpoint = module.primary.kafka_cluster_bootstrap_endpoint
  }
}

resource "confluent_cluster_link" "failover-jump" {
  link_name = "demo-link"
  link_mode = "SOURCE"
  connection_mode = "OUTBOUND"
  source_kafka_cluster {
    id = module.failover.kafka_cluster_id
    rest_endpoint = module.failover.kafka_cluster_rest_endpoint
    credentials {
      key    = module.failover.kafka_cluster_api_key_id
      secret = module.failover.kafka_cluster_api_secret_key
    }
  }
  destination_kafka_cluster {
    id = confluent_kafka_cluster.jump-over.id
    bootstrap_endpoint = confluent_kafka_cluster.jump-over.bootstrap_endpoint
    credentials {
      key    = confluent_api_key.jump-api-key.id
      secret = confluent_api_key.jump-api-key.secret
    }
  }
  depends_on = [
  confluent_cluster_link.jump-failover
  ]
}

resource "confluent_cluster_link" "jump-failover" {
  link_name = "demo-link"
  link_mode = "DESTINATION"
  connection_mode = "INBOUND"
  destination_kafka_cluster {
    id = confluent_kafka_cluster.jump-over.id
    rest_endpoint = confluent_kafka_cluster.jump-over.rest_endpoint
    credentials {
      key    = confluent_api_key.jump-api-key.id
      secret = confluent_api_key.jump-api-key.secret
    }
  }
  source_kafka_cluster {
    id = module.failover.kafka_cluster_id
    bootstrap_endpoint = module.failover.kafka_cluster_bootstrap_endpoint
  }
}

#output "api-key" {
#  value       = "${module.failover.kafka_cluster_api_key_id}"
#  sensitive = true
#  description = "api-key-id "
#}
#output "api-key-secret" {
#  value = "${module.failover.kafka_cluster_api_secret_key}"
#  sensitive = true
#}
