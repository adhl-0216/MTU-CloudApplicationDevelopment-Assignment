variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "docker_image" {
  description = "Full container image name and tag (e.g. username/image:tag)"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where resources will be created"
  type        = list(string)
}

variable "lab_role_arn" {
  description = "ARN of the AWS Learner Lab Role"
  type        = string
}
