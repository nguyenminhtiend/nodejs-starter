provider "aws" {
  region  = var.region
  profile = "terraform"
}

terraform {
  backend "s3" {
    bucket  = "nodejs-starter-artifacts"
    key     = "terraform/terraform.tfstate"
    region  = "ap-southeast-1"
    profile = "terraform"
  }
}
# module "ecr" {
#   source  = "./ecr"
#   tags = var.tags
# }

module "vpc" {
  source = "./vpc"
  tags   = var.tags
}

module "iam" {
  source = "./iam"
}

module "cloudwatch" {
  source    = "./cloudwatch"
  log_group = var.log_group
  tags      = var.tags
}

module "alb" {
  source         = "./alb"
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.public_subnets
  security_group = module.vpc.alb_sg
  tags           = var.tags
}

module "ecs" {
  source         = "./ecs"
  execution_role = module.iam.execution_role_arn
  subnets        = module.vpc.private_subnets
  target_group   = module.alb.target_group
  image          = var.image
  desired_count  = var.desired_count
  security_group = module.vpc.ecs_sg
  log_group      = var.log_group
  tags           = var.tags

}
