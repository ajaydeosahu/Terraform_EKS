output "region" {
  description = "AWS Region for the EKS cluster"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_id
}

output "environment" {
  description = "Environment Name for the EKS cluster"
  value       = var.environment
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_primary_security_group_id
}

output "kubeconfig_context_name" {
  description = "Name of the kubeconfig context"
  value       = module.eks.cluster_arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "_2cluster_security_group_id" {
  description = "ID of the cluster node shared security group"
  value       = module.eks.cluster_security_group_id
}

output "worker_iam_role_arn" {
  description = "ARN of the EKS Worker Role"
  value = module.eks.worker_iam_role_arn
}