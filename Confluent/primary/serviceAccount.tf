resource "confluent_service_account" "manager-source-cluster" {
  display_name = "manager-source-cluster"
  description = "Service account to manage the source cluster "
}

resource "confluent_role_binding" "source-cluster-admin" {
  crn_pattern = confluent_kafka_cluster.source.rbac_crn
  principal   = "User:${confluent_service_account.manager-source-cluster.id}"
  role_name   = "CloudClusterAdmin"
}

resource "confluent_api_key" "source-api-key" {
  display_name = "cluster-manager-api-key"
  disable_wait_for_ready = true
  description = "Kafka API Key that is owned by cluster manager service acocunt"
  owner {
    api_version = confluent_service_account.manager-source-cluster.api_version
    id          = confluent_service_account.manager-source-cluster.id
    kind        = confluent_service_account.manager-source-cluster.kind
  }
  managed_resource {
    api_version = confluent_kafka_cluster.source.api_version
    id          = confluent_kafka_cluster.source.id
    kind        = confluent_kafka_cluster.source.kind
    environment {
      id = var.environement-id
    }
  }
  depends_on = [
    confluent_role_binding.source-cluster-admin,
    confluent_peering.aws-source,
    aws_route.source-route
  ]
}

provider "aws" {
  region = var.source-region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


data "aws_vpc_peering_connection" "source-accepter" {
  vpc_id = confluent_network.aws-source-peering.aws[0].vpc
  peer_vpc_id = confluent_peering.aws-source.aws[0].vpc
  peer_owner_id = confluent_peering.aws-source.aws[0].account
  peer_region = var.source-region

}

resource "aws_vpc_peering_connection_accepter" "peering" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.source-accepter.id
  auto_accept = false
}

data "aws_route_tables" "source-rts" {
  vpc_id = "vpc-06fb07384264ca2ec"
}

resource "aws_route" "source-route" {
  for_each = toset(data.aws_route_tables.source-rts.ids)
  route_table_id = each.key
  destination_cidr_block = confluent_network.aws-source-peering.cidr
  vpc_peering_connection_id = data.aws_vpc_peering_connection.source-accepter.id
}