## Terraform provider

provider "aws" {
  region = var.region
  default_tags {
    tags = var.additional_tags
  }
}

# Using these data sources allows the configuration to be generic for any region.

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

# Kubernetes provider

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Helm provider

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
