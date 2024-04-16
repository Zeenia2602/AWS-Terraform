# Configure the AWS Provider
module "primary" {
  source = "./primary"
  region = "us-east-1"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  PRIVATE_KEY = "stream-key-pair"
  PUBLIC_KEY = "stream-key-pair.pub"
  USER_DATA = "server.sh"
}

# For Failover
module "faliover" {
  source = "./Failover"
  region = "us-east-2"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  PRIVATE_KEY = "failover-key-pair"
  PUBLIC_KEY = "failover-key-pair.pub"
  USER_DATA = "server.sh"
}
output "instances" {
  value       = "${module.primary.instances}"
  description = "User DATA "
}
