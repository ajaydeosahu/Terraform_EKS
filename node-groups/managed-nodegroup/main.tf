data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks" {
  name = var.cluster_id
}

data "aws_ami" "launch_template_ami" {
  owners      = ["602401143452"] ## Amazon Account Id
  most_recent = true

  filter {
    name   = "name"
    values = [format("%s-%s-%s", "amazon-eks-node", data.aws_eks_cluster.eks.version , "v*")]
  }
}


data "template_file" "launch_template_userdata" {
  template = file("${path.module}/templates/custom-bootstrap-script.sh.tpl")

  vars = {
    cluster_name                 = var.cluster_id
    endpoint                     = data.aws_eks_cluster.eks.endpoint
    cluster_auth_base64          = data.aws_eks_cluster.eks.certificate_authority[0].data
    image_high_threshold_percent = var.image_high_threshold_percent
    image_low_threshold_percent  = var.image_low_threshold_percent
    eventRecordQPS               = var.eventRecordQPS
  }
}



resource "aws_launch_template" "eks_template" {
  count           = 1 
  name            = format("%s-%s", var.name, "launch-template")
  default_version = 1
  key_name        = var.public_key_eks
  user_data       = base64encode(data.template_file.launch_template_userdata.rendered)
  image_id        = data.aws_ami.launch_template_ami.image_id 

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = var.ebs_volume_type
      delete_on_termination = var.delete_ebs_on_termination
      encrypted             = var.ebs_encrypted
      kms_key_id            = var.kms_key_id
    }
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = var.delete_ebs_on_termination
    security_groups             = [data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = format("%s-%s", var.environment, var.name, )
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_eks_node_group" "managed_ng" {

  node_group_name = var.name
  cluster_name    = var.cluster_id
  node_role_arn   = var.worker_iam_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  labels = var.k8s_labels

  instance_types       = var.instance_types
  capacity_type        = var.capacity_type 


  launch_template {
    id      = aws_launch_template.eks_template[0].id
    version = aws_launch_template.eks_template[0].default_version
  }

}

