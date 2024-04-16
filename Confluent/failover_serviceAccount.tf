## For disaster Recovery
#resource "confluent_service_account" "disasterRecovery" {
#  display_name = "disaster-recovery-service-account"
#  description = "Service account to manager the Disaster recovery cluster"
#}
#
#resource "confluent_role_binding" "failover-cluster-admin" {
#  crn_pattern = confluent_kafka_cluster.failover.rbac_crn
#  principal   = "User:${confluent_service_account.disasterRecovery.id}"
#  role_name   = "CloudClusterAdmin"
#}
#resource "confluent_api_key" "disasterRecovery-api-key" {
#  display_name = "disaster-recovery-api-key"
#  description = "Kafka API Key that is owned by Disaster recovery cluster service account"
#  owner {
#    api_version = confluent_service_account.disasterRecovery.api_version
#    id          = confluent_service_account.disasterRecovery.id
#    kind        = confluent_service_account.disasterRecovery.kind
#  }
#  managed_resource {
#    api_version = confluent_kafka_cluster.failover.api_version
#    id          = confluent_kafka_cluster.failover.id
#    kind        = confluent_kafka_cluster.failover.kind
#    environment {
#      id = confluent_environment.AWS_terraform.id
#    }
#  }
#  depends_on = [
#    confluent_peering.aws-disaster-recovery,
#    confluent_role_binding.failover-cluster-admin
##    aws_route.route
#  ]
#}
##module "failover" {
##  source = "./failover"
##  failover-region = "us-east-2"
##}
##data "aws_vpc_peering_connection" "accepter" {
##  vpc_id = confluent_network.aws-disaster-vpc-peering.aws[0]
##  peer_vpc_id = confluent_peering.aws-disaster-recovery.aws[0].vpc
##}
##
##resource "aws_vpc_peering_connection_accepter" "peer" {
##  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
##  auto_accept = true
##}
##
##data "aws_route_tables" "rts" {
##  vpc_id = "vpc-03d135978f80c46e2"
##}
##
##resource "aws_route" "route" {
##  for_each = toset(data.aws_route_tables.rts.ids)
##  route_table_id = each.key
##  destination_cidr_block = confluent_network.aws-disaster-vpc-peering.cidr
##  vpc_peering_connection_id = data.aws_vpc_peering_connection.accepter.id
##}