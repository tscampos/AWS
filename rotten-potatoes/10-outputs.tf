# output "alb_hostname" {
#   value = aws_alb.application_load_balancer.dns_name
# }

# output "instance_public_ip" {
#   value       = aws_instance.example.public_ip
#   description = "Public IP address of the EC2 instance"
# }

# output "application_endpoint" {
#   value = aws_lb.load_balancer.dns_name
# }

# output "application_endpoint" {
#   value = aws_lb_target_group.target_group.arn
# }

# output "application_url" {
#   value = "http://${aws_alb.application_load_balancer.dns_name}:${aws_lb_target_group.target_group_5000.port}"
# }