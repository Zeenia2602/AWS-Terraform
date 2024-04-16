resource "confluent_kafka_cluster" "jump-over" {
  cloud        = "AWS"
  display_name = "jump-over-cluster"
  region       = "us-east-2"
  availability = "SINGLE_ZONE"
  dedicated {
    cku = 1
  }
  environment {
    id = confluent_environment.AWS_terraform.id
  }
}

resource "confluent_service_account" "jump-over-cluster" {
  display_name = "jump-cluster"
  description = "Service account to manage the jump cluster "
}

resource "confluent_role_binding" "jump-cluster-admin" {
  crn_pattern = confluent_kafka_cluster.jump-over.rbac_crn
  principal   = "User:${confluent_service_account.jump-over-cluster.id}"
  role_name   = "CloudClusterAdmin"
}

resource "confluent_api_key" "jump-api-key" {
  display_name = "jump-cluster-api-key"
  disable_wait_for_ready = true
  description = "Kafka API Key that is owned by cluster manager service acocunt"
  owner {
    api_version = confluent_service_account.jump-over-cluster.api_version
    id          = confluent_service_account.jump-over-cluster.id
    kind        = confluent_service_account.jump-over-cluster.kind
  }
  managed_resource {
    api_version = confluent_kafka_cluster.jump-over.api_version
    id          = confluent_kafka_cluster.jump-over.id
    kind        = confluent_kafka_cluster.jump-over.kind
    environment {
      id = confluent_environment.AWS_terraform.id
    }
  }
  depends_on = [
    confluent_role_binding.jump-cluster-admin
  ]
}

