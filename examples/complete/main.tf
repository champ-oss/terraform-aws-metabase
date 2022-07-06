provider "aws" {
  region = "us-west-2"
}

locals {
  git = "terraform-aws-metabase"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=v1.0.24-900228d"
  git                      = local.git
  availability_zones_count = 2
  retention_in_days        = 1
  create_private_subnets   = true
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.61-bdcb404"
  git               = local.git
  domain_name       = "${local.git}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "this" {
  source             = "../../"
  certificate_arn    = module.acm.arn
  domain             = "${local.git}.${data.aws_route53_zone.this.name}"
  private_subnet_ids = module.vpc.private_subnets_ids
  public_subnet_ids  = module.vpc.public_subnets_ids
  vpc_id             = module.vpc.vpc_id
  zone_id            = data.aws_route53_zone.this.zone_id
  id                 = local.git
  protect            = false
  https_egress_only  = true
  tags = {
    git     = local.git
    cost    = "module"
    creator = "terraform"
  }
}