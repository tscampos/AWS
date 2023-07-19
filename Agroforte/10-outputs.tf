output "alb_hostname" {
  value = aws_alb.application_load_balancer.dns_name
}

output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  description = "Public IP address of the EC2 instance"
}