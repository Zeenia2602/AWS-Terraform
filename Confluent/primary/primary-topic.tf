# Create topic on Source cluster
resource "confluent_kafka_topic" "source" {
  kafka_cluster {
    id = confluent_kafka_cluster.source.id
  }
  topic_name = "source"
  rest_endpoint = confluent_kafka_cluster.source.rest_endpoint
  credentials {
    key    = confluent_api_key.source-api-key.id
    secret = confluent_api_key.source-api-key.secret
  }

}
