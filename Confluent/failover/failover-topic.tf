# Create topic on Source cluster
resource "confluent_kafka_topic" "failover" {
  kafka_cluster {
    id = confluent_kafka_cluster.failover.id
  }
  topic_name = "failover"
  rest_endpoint = confluent_kafka_cluster.failover.rest_endpoint
  credentials {
    key    = confluent_api_key.disasterRecovery-api-key.id
    secret = confluent_api_key.disasterRecovery-api-key.secret
  }

}
