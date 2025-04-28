variable "docker_image" {
  description = "Full container image name and tag (e.g. username/image:tag)"
  type        = string
  default     = "215262883158.dkr.ecr.us-east-1.amazonaws.com/mtu-cad/petclinic:latest"
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}
