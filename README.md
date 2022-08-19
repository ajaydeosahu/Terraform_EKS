## IAM permission Required to run this module

- kms-full-access
- IAMFullAccess
- eks-full-access
- AmazonEC2FullAccess
- AmazonVPCFullAccess

# AWS Network Terraform module

Terraform module to create EKS cluster resources for workload deployment on AWS Cloud.

## Usage Example

```hcl
module "eks" {
  source = "git::https://{GIT_USER}:{GIT_TOKEN}@gitlab.com/squareops/sal/terraform/aws/eks.git?ref=dev"

  region                               = var.region
  environment                          = var.environment
  name                                 = var.name
  cluster_enabled_log_types            = ["api", "scheduler"]
  cluster_version                      = "1.21"
  public_key_eks             = module.key_pair_eks.key_pair_name 
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnets
  cluster_autoscaler_version = "1.1.0"
  metrics_server_version     = "6.0.5"
  ingress_nginx_enabled      = var.ingress_nginx_enabled
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

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.43.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 17.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.app_node_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.app_node_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.infra_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.kubernetes_pvc_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.SSMManagedInstanceCore_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_kms_key_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.eks_template_app_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.eks_template_app_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.eks_template_infra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [null_resource.get_kubeconfig](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.launch_template_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy.SSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.launch_template_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Warning"></a> [Warning](#input\_Warning) | n/a | `string` | `"Warning!! !SAVE THIS PEM FILE FOR ACCESSING WORKER NODES !"` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Tags for resources | `map(string)` | `{}` | no |
| <a name="input_application_ng_name_demand"></a> [application\_ng\_name\_demand](#input\_application\_ng\_name\_demand) | node group name for on demand application | `string` | `""` | no |
| <a name="input_application_ng_name_spot"></a> [application\_ng\_name\_spot](#input\_application\_ng\_name\_spot) | node group name for spot application | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Set true if you want to enable network interface for launch template | `bool` | `false` | no |
| <a name="input_block_duration_minutes"></a> [block\_duration\_minutes](#input\_block\_duration\_minutes) | n/a | `number` | `60` | no |
| <a name="input_capacity_type_app_demand"></a> [capacity\_type\_app\_demand](#input\_capacity\_type\_app\_demand) | Capacity type for application On demand node | `string` | `""` | no |
| <a name="input_capacity_type_app_spot"></a> [capacity\_type\_app\_spot](#input\_capacity\_type\_app\_spot) | Capacity type for application Spot node | `string` | `""` | no |
| <a name="input_capacity_type_infra"></a> [capacity\_type\_infra](#input\_capacity\_type\_infra) | Capacity type for Infra node | `string` | `""` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | A list of the desired control plane logs to enable for EKS cluster | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS public API server endpoint | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_cluster_log_retention_in_days"></a> [cluster\_log\_retention\_in\_days](#input\_cluster\_log\_retention\_in\_days) | Retention period for EKS cluster logs | `number` | `90` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes <major>.<minor> version to use for the EKS cluster | `string` | `""` | no |
| <a name="input_create_application_on_demand"></a> [create\_application\_on\_demand](#input\_create\_application\_on\_demand) | Set true if you want the application Node group instance On Demand type | `bool` | `false` | no |
| <a name="input_create_application_spot"></a> [create\_application\_spot](#input\_create\_application\_spot) | Set true if you want the application Node group instance On Spot type | `bool` | `false` | no |
| <a name="input_create_infra"></a> [create\_infra](#input\_create\_infra) | Set true if you want to create the infra Node group | `bool` | `true` | no |
| <a name="input_desired_capacity_app_demand"></a> [desired\_capacity\_app\_demand](#input\_desired\_capacity\_app\_demand) | define the number of nodes required for application ON Demand instance | `number` | `3` | no |
| <a name="input_desired_capacity_app_spot"></a> [desired\_capacity\_app\_spot](#input\_desired\_capacity\_app\_spot) | define the number of nodes required for application Spot instance | `number` | `3` | no |
| <a name="input_desired_capacity_infra"></a> [desired\_capacity\_infra](#input\_desired\_capacity\_infra) | define the number of nodes required for Infra | `number` | `3` | no |
| <a name="input_eks_keypair_private_key"></a> [eks\_keypair\_private\_key](#input\_eks\_keypair\_private\_key) | The private key for EkS cluster | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier for the EKS cluster | `string` | `""` | no |
| <a name="input_eventRecordQPS"></a> [eventRecordQPS](#input\_eventRecordQPS) | n/a | `number` | `5` | no |
| <a name="input_image_high_threshold_percent"></a> [image\_high\_threshold\_percent](#input\_image\_high\_threshold\_percent) | n/a | `number` | `60` | no |
| <a name="input_image_low_threshold_percent"></a> [image\_low\_threshold\_percent](#input\_image\_low\_threshold\_percent) | n/a | `number` | `40` | no |
| <a name="input_infra_ng_name"></a> [infra\_ng\_name](#input\_infra\_ng\_name) | Infra node group name | `string` | `""` | no |
| <a name="input_instance_interruption_behavior"></a> [instance\_interruption\_behavior](#input\_instance\_interruption\_behavior) | n/a | `string` | `""` | no |
| <a name="input_instance_type_app_demand"></a> [instance\_type\_app\_demand](#input\_instance\_type\_app\_demand) | Specify the On demand instance type for application | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_instance_type_app_spot"></a> [instance\_type\_app\_spot](#input\_instance\_type\_app\_spot) | Specify the Spot instance type for application | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_instance_type_infra"></a> [instance\_type\_infra](#input\_instance\_type\_infra) | Specify the instance type for Infra | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_launch_template_id"></a> [launch\_template\_id](#input\_launch\_template\_id) | eks launch template for node group | `string` | `""` | no |
| <a name="input_max_capacity_app_demand"></a> [max\_capacity\_app\_demand](#input\_max\_capacity\_app\_demand) | Maximum number of nodes for On Demand application node group | `number` | `5` | no |
| <a name="input_max_capacity_app_spot"></a> [max\_capacity\_app\_spot](#input\_max\_capacity\_app\_spot) | Maximum number of nodes for Spot application node group | `number` | `5` | no |
| <a name="input_max_capacity_infra"></a> [max\_capacity\_infra](#input\_max\_capacity\_infra) | Maximum number of nodes for Infra node group | `number` | `5` | no |
| <a name="input_max_price"></a> [max\_price](#input\_max\_price) | n/a | `string` | `null` | no |
| <a name="input_min_capacity_app_demand"></a> [min\_capacity\_app\_demand](#input\_min\_capacity\_app\_demand) | Minimum number of nodes for On Demand application node group | `number` | `1` | no |
| <a name="input_min_capacity_app_spot"></a> [min\_capacity\_app\_spot](#input\_min\_capacity\_app\_spot) | Minimum number of nodes for Spot application node group | `number` | `1` | no |
| <a name="input_min_capacity_infra"></a> [min\_capacity\_infra](#input\_min\_capacity\_infra) | Minimum number of nodes for Infra node group | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the EKS cluster | `string` | `""` | no |
| <a name="input_name_ssm_parameter"></a> [name\_ssm\_parameter](#input\_name\_ssm\_parameter) | n/a | `string` | `null` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnets of the VPC which can be used by EKS | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_public_key_eks"></a> [public\_key\_eks](#input\_public\_key\_eks) | The public key for EkS cluster | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for the EKS cluster | `string` | `""` | no |
| <a name="input_root_volume_app_gb_demand"></a> [root\_volume\_app\_gb\_demand](#input\_root\_volume\_app\_gb\_demand) | EBS volume size that will attach to the application On Demand node | `number` | `20` | no |
| <a name="input_root_volume_app_gb_spot"></a> [root\_volume\_app\_gb\_spot](#input\_root\_volume\_app\_gb\_spot) | EBS volume size that will attach to the application Spot node | `number` | `20` | no |
| <a name="input_root_volume_infra_gb"></a> [root\_volume\_infra\_gb](#input\_root\_volume\_infra\_gb) | EBS volume size that will attach to the Infra node | `number` | `20` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster and its nodes will be provisioned | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output__2cluster_security_group_id"></a> [\_2cluster\_security\_group\_id](#output\_\_2cluster\_security\_group\_id) | ID of the cluster node shared security group |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for EKS control plane |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group ids attached to the cluster control plane |
| <a name="output_environment"></a> [environment](#output\_environment) | Environment Name for the EKS cluster |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID |
| <a name="output_kubeconfig_context_name"></a> [kubeconfig\_context\_name](#output\_kubeconfig\_context\_name) | Name of the kubeconfig context |
| <a name="output_region"></a> [region](#output\_region) | AWS Region for the EKS cluster |
<!-- END_TF_DOCS -->
