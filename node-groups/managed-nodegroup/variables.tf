variable "cluster_id" {
    type = string
    default = ""
    description = "Cluster ID for EKS"
}

variable "image_high_threshold_percent" {
  default = 60
  type    = number
}

variable "image_low_threshold_percent" {
  default = 40
  type    = number
}

variable "eventRecordQPS" {
  default = 5
  type    = number
}

variable "environment" {
  default = null
  type    = string
}


variable "public_key_eks" {
  description = "The public key for EkS cluster"
  default = ""
  type    = string
}

variable "kms_key_id" {
    type = string
    default = ""
}

variable "name" {
  description = "Specify the name of the EKS Nodegroup"
  default = "EKS-nodegroup"
  type    = string
}


variable "associate_public_ip_address" {
  description = "Set true if you want to enable network interface for launch template"
  default = true
  type    = bool
}

variable "enable_monitoring" {
  type = bool
  default = true
  }

variable "instance_types" {
  type = list
  default = ["t3.medium"]
}

variable "capacity_type" {
  default = "ON_DEMAND"
  type = string
  description = "Capacity type ON_DEMAND/SPot"
}



variable "worker_iam_role_arn" {
    type = string
    default = ""
}

variable "subnet_ids" {
  description = " subnets of the VPC which can be used by EKS"
  default = [""]
  type    = list(string)
}

variable "tags" {
  type = any
  default = {}
  description = "tags for the nodegroup"
}

variable "k8s_labels" {
  type = map
  default = {}
  description = "K8s label for the nodegroups"
}



variable "min_size" {
  type = string
  default = "1"
}

variable "max_size" {
  type = string
  default = "3"
}

variable "desired_size" {
  type = string
  default = "3"
}

variable "ebs_volume_size" {
  type = string
  default = "50"
}

variable "ebs_volume_type" {
  type = string
  default = "gp3"
}

variable "delete_ebs_on_termination" {
  type = bool
  default = true
}

variable "ebs_encrypted" {
  type = bool
  default = true
}
