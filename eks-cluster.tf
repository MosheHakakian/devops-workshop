module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access  = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids  # Use subnets from variables

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = [var.instance_type]
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
     "${var.node_group_name}" = {
      min_size     = var.min_capacity
      max_size     = var.max_capacity
      desired_size = var.desired_capacity
      instance_types = [var.instance_type]  
    }
  }
}
