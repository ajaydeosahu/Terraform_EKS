data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


resource "aws_iam_policy" "kubernetes_pvc_kms_policy" {
  name        = format("%s-%s", module.eks.cluster_id, "kubernetes-pvc-kms-policy")
  description = "Allow kubernetes pvc to get access of KMS."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "kms:CreateGrant",
            "kms:Decrypt",
            "kms:GenerateDataKeyWithoutPlaintext"
        ],
        "Resource": "${var.kms_key_id}"
      }
  ]
}
EOF  
}

data "aws_iam_policy" "SSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore_attachment" {
  role       = module.eks.worker_iam_role_name
  policy_arn = data.aws_iam_policy.SSMManagedInstanceCore.arn
}


resource "aws_iam_role_policy_attachment" "eks_kms_key_policy_attachment" {
  role       = module.eks.cluster_iam_role_name
  policy_arn = aws_iam_policy.kubernetes_pvc_kms_policy.arn
}

module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "17.1.0"
  cluster_name              = format("%s-%s", var.environment, var.name)
  cluster_enabled_log_types = var.cluster_enabled_log_types
  subnets                   = var.private_subnet_ids
  cluster_version           = var.cluster_version
  enable_irsa               = true

  tags = {
    "Name"        = format("%s-%s", var.environment, var.name)
    "Environment" = var.environment
  }

  vpc_id                               = var.vpc_id
  manage_aws_auth                      = false
  write_kubeconfig                     = false
  cluster_log_retention_in_days        = var.cluster_log_retention_in_days
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  cluster_encryption_config = [
    {
      provider_key_arn = var.kms_key_id
      resources        = ["secrets"]
    }
  ]
}

resource "aws_iam_role_policy_attachment" "node_autoscaler_policy" {
  policy_arn = aws_iam_policy.node_autoscaler_policy.arn
  role       = module.eks.worker_iam_role_name
}

resource "aws_iam_policy" "node_autoscaler_policy" {
  name        = format("%s-%s-%s-node-autoscaler-policy", var.environment, var.name, module.eks.cluster_id)
  path        = "/"
  description = "Node auto scaler policy for node groups."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "null_resource" "get_kubeconfig" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.region}"
  }
}
