#### Create topic on Source cluster
#resource "confluent_kafka_topic" "source" {
#  kafka_cluster {
#    id = confluent_kafka_cluster.source.id
#  }
#  topic_name = "source"
#  rest_endpoint = confluent_kafka_cluster.source.rest_endpoint
#  credentials {
#    key    = confluent_api_key.source-api-key.id
#    secret = confluent_api_key.source-api-key.secret
#  }
#
#}
##
##
### Creating a mirror topic on Disaster Recovery cluster

resource "confluent_kafka_mirror_topic" "failover-topic" {
  source_kafka_topic {
    topic_name = "failover"
  }
  cluster_link {
    link_name = confluent_cluster_link.failover-jump.link_name
  }
  kafka_cluster {
    id = confluent_kafka_cluster.jump-over.id
    rest_endpoint = confluent_kafka_cluster.jump-over.rest_endpoint
    credentials {
      key    = confluent_api_key.jump-api-key.id
      secret = confluent_api_key.jump-api-key.secret
    }
  }
  depends_on = [
  confluent_cluster_link.failover-jump,
  confluent_cluster_link.jump-failover
  ]
}
resource "confluent_kafka_mirror_topic" "jumpover-topic" {
  source_kafka_topic {
    topic_name = module.primary.kafka_topic_name
  }
  cluster_link {
    link_name = confluent_cluster_link.source-jumpOver.link_name
  }
  kafka_cluster {
    id = confluent_kafka_cluster.jump-over.id
    rest_endpoint = confluent_kafka_cluster.jump-over.rest_endpoint
    credentials {
      key    = confluent_api_key.jump-api-key.id
      secret = confluent_api_key.jump-api-key.secret
    }
  }
  depends_on = [
    confluent_cluster_link.source-jumpOver,
    confluent_cluster_link.jump-source
  ]
}