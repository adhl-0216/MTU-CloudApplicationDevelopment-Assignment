module "fargate" {
  source        = "./modules/fargate"
  cluster_name = "ecs-fargate-cluster"

  docker_image  = var.docker_image
  aws_region    = var.aws_region
  
  lab_role_arn  = data.aws_iam_role.lab_role.arn
  vpc_id        = data.aws_vpc.default.id
  subnet_ids    = data.aws_subnets.default.ids
}

module "ec2" {
  source        = "./modules/ec2"
  cluster_name = "ecs-ec2-cluster"

  docker_image  = var.docker_image
  aws_region    = var.aws_region

  lab_role_arn  = data.aws_iam_role.lab_role.arn
  vpc_id        = data.aws_vpc.default.id
  subnet_ids    = data.aws_subnets.default.ids
}

terraform {
  required_version = ">= 1.0.0"
  cloud {
    organization = "ADHL_DEV" 

    workspaces {
      name = "AWS_ECS_CD"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}