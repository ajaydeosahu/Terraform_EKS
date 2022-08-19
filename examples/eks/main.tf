provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  environment = "dev"
  name        = "skaf"
}

module "eks" {
  source = "../../"

  region                               = local.region
  environment                          = local.environment
  name                                 = local.name
  cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_version                      = "1.21"
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  public_key_eks             = module.key_pair_eks.key_pair_name 
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnets
  cert_manager_enabled       = true
  cert_manager_version       = "1.0.3"
  cert_manager_email         = "support@example.com"
  cluster_autoscaler_version = "1.1.0"
  metrics_server_version     = "6.0.5"
  ingress_nginx_enabled      = true
  ingress_nginx_version      = "3.10.1"
  aws_load_balancer_version  = "1.0.0"

  # Infra Node On Demand Group Configuration
  infra_ng_name          = "infra-ng"
  instance_type_infra    = ["t3a.medium"]
  min_capacity_infra     = 1
  desired_capacity_infra = 1
  max_capacity_infra     = 2
  capacity_type_infra    = "ON_DEMAND"
  root_volume_infra_gb   = 10

  # Application Node On Demand Group Configuration
  create_application_on_demand = true
  application_ng_name_demand   = "application-ng"
  instance_type_app_demand     = ["t3a.medium"]
  min_capacity_app_demand      = 1
  desired_capacity_app_demand  = 1
  max_capacity_app_demand      = 2
  capacity_type_app_demand     = "ON_DEMAND"
  root_volume_app_gb_demand    = 10

}
