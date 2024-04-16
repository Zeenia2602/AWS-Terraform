output "instances" {
  value       = "${aws_instance.stream.user_data}"
  description = "User DATA "
}