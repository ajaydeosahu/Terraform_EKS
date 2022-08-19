## COMMON VARIABLES

variable "additional_tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
  }
}


variable "block_duration_minutes" {
  default = 60
  type    = number
}



variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable for EKS cluster"
  default     = [""]
  type        = list(string)
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = [""]
  type        = list(string)
}

variable "cluster_log_retention_in_days" {
  description = "Retention period for EKS cluster logs"
  default     = 90
  type        = number
}

variable "cluster_version" {
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster"
  default     = ""
  type        = string
}

variable "environment" {
  description = "Environment identifier for the EKS cluster"
  default     = ""
  type        = string
}

variable "instance_interruption_behavior" {
  default = ""
  type    = string
}

variable "max_price" {
  default = null
  type    = string
}

variable "name" {
  description = "Specify the name of the EKS cluster"
  default     = ""
  type        = string
}

variable "region" {
  description = "AWS region for the EKS cluster"
  default     = ""
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets of the VPC which can be used by EKS"
  default     = [""]
  type        = list(string)
}


variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
  default     = ""
  type        = string
}

variable "Warning" {
  default = "Warning!! !SAVE THIS PEM FILE FOR ACCESSING WORKER NODES !"
  type    = string
}

variable "name_ssm_parameter" {
  default = null
  type    = string
}

variable "eks_keypair_private_key" {
  description = "The private key for EkS cluster"
  type        = bool
  default     = false
}

variable "public_key_eks" {
  description = "The public key for EkS cluster"
  default     = ""
  type        = string
}

variable "kms_key_id" {
  type = string
  default = ""
  description = "KMS key to Encrypt EKS resources."
}