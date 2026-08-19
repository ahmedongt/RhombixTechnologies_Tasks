output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.rhombix_vpc.id
}

output "ec2_public_ip" {
  description = "Public IP of the deployed EC2 server"
  value       = aws_instance.rhombix_web_server.public_ip
}

output "ec2_public_url" {
  description = "Web address for testing Nginx deployment"
  value       = "http://${aws_instance.rhombix_web_server.public_ip}"
}