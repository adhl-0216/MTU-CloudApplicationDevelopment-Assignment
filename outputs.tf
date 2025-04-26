output "ec2_alb_dns_name" {
  description = "DNS name of the EC2 ALB"
  value       = module.ec2.alb_dns_name
}

output "ec2_cluster_id" {
  description = "ID of the ECS EC2 cluster"
  value       = module.ec2.cluster_id
}

output "ec2_service_name" {
  description = "Name of the ECS EC2 service"
  value       = module.ec2.service_name
}

output "fargate_alb_dns_name" {
  description = "DNS name of the Fargate Application Load Balancer"
  value       = module.fargate.alb_dns_name
}

output "fargate_cluster_id" {
  description = "ID of the Fargate ECS cluster"
  value       = module.fargate.cluster_id
}

output "fargate_service_name" {
  description = "Name of the Fargate ECS service"
  value       = module.fargate.service_name
}
