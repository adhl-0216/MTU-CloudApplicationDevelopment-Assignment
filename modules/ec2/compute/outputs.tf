output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.ecs.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.ecs.arn
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.ecs.id
}

output "launch_template_version" {
  description = "Latest version of the Launch Template"
  value       = aws_launch_template.ecs.latest_version
}
