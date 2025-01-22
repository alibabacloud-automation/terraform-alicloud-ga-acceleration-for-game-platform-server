provider "alicloud" {
  region = "ap-southeast-1"
}

module "complete" {
  source = "../.."

  vpc           = var.vpc
  vswitch_zones = var.vswitch_zones

  alb_server_group = var.alb_server_group

  ga_accelerator        = var.ga_accelerator
  ga_endpoint_group     = var.ga_endpoint_group
  ga_accelerate_regions = var.ga_accelerate_regions
}
