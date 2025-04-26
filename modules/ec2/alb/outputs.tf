output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "tasks_security_group_id" {
  description = "ID of the security group for ECS tasks"
  value       = aws_security_group.tasks.id
}
