output "kafka_cluster_id" {
  value = confluent_kafka_cluster.source.id
}

output "kafka_cluster_rest_endpoint" {
  value = confluent_kafka_cluster.source.rest_endpoint
}

output "kafka_cluster_bootstrap_endpoint" {
  value = confluent_kafka_cluster.source.bootstrap_endpoint
}

output "kafka_cluster_api_key_id" {
  value = confluent_api_key.source-api-key.id
}

output "kafka_cluster_api_secret_key" {
  value = confluent_api_key.source-api-key.secret
}

output "kafka_topic_name" {
  value = confluent_kafka_topic.source.topic_name
}