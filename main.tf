# Create subnets using a loop with count
# resource "aws_subnet" "subnets" {
#  count             = length(var.cidr_blocks)
 # vpc_id            = var.vpc_id
 # cidr_block        = var.cidr_blocks[count.index]
 # availability_zone = var.availability_zones[count.index]

 # tags = {
  #  Name = var.subnet_names[count.index]
 # }
# }

# Create Route Table
#resource "aws_route_table" "main" {
#  vpc_id = var.vpc_id

#  tags = {
#    Name = "moshe-route-table"
#  }

    # Route for internet-bound traffic through NAT Gateway
 # route {
 #   cidr_block     = "0.0.0.0/0"  # Default route for all outbound traffic
  #  nat_gateway_id = "nat-0440e3c0e49d26497"  # Replace with your actual NAT Gateway ID
 # }
#}

# Associate subnets with the route table using a loop
#resource "aws_route_table_association" "subnet_associations" {
#  count         = length(var.cidr_blocks)
#  subnet_id     = aws_subnet.subnets[count.index].id
#  route_table_id = aws_route_table.main.id
#}

# Create an S3 bucket policy that references the external JSON file
#resource "aws_s3_bucket_policy" "bucket_policy" {
 # bucket = var.name_bucket
  #policy = file("bucket-policy.json")
#}

#############
# Load Balancer Controller IAM Policy
resource "aws_iam_policy" "load_balancer_controller_policy" {
  name        = "load-balancer-controller-IAMPolicy"
  path        = "/"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = file("iam_policy.json") 
}

# Create IAM Role for Load Balancer Controller
resource "aws_iam_role" "load_balancer_controller_role" {
  name               = "moshe-load-balancer-controller"
  assume_role_policy = file("lb-trust-policy.json")  # Load JSON trust policy
}

# Attach the existing Load Balancer Controller IAM policy
resource "aws_iam_role_policy_attachment" "lb_controller_policy_attachment" {
  role       = aws_iam_role.load_balancer_controller_role.name
  policy_arn = "arn:aws:iam::730335218716:policy/AWSLoadBalancerControllerIAMPolicy"
}

#resource "helm_release" "moshe_load_balancer_controller" {
#  name       = "moshe-load-balancer-controller"
#  repository = "https://aws.github.io/eks-charts"
#  chart      = "aws-load-balancer-controller"
#  namespace  = "kube-system"
#  version    = "1.4.7"  # Specify the desired chart version

#  set {
#    name  = "clusterName"
#    value = var.cluster_name  # Reference your cluster name variable
#  }

#  set {
 #   name  = "serviceAccount.create"
 #   value = "false"
 # }

 # set {
 #   name  = "serviceAccount.name"
 #   value = "aws-load-balancer-controller"  # The service account you created
 # }
#}


#####

resource "aws_route53_record" "moshe_route53_record" {
  zone_id = var.hosted_zone_id
  name    = "moshe.${var.domain_name}"  
  type    = "CNAME"
  ttl     = 60
  records = [var.load_balancer_dns]  # DNS name of your load balancer
}

# CoreDNS Addon
resource "aws_eks_addon" "coreends" {
  cluster_name = module.eks.cluster_name
  addon_name = "coredns"
  addon_version = "v1.10.1-eksbuild.11"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [ 
    module.eks
     ]
}

# AWS EBS CSI Driver Addon
resource "aws_eks_addon" "aws_ebs_csi" {
  cluster_name               = module.eks.cluster_name
  addon_name                 = "aws-ebs-csi-driver"
  addon_version              = "v1.35.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                 = [module.eks]
}

# EKS Cluster Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access  = true
  enable_cluster_creator_admin_permissions = false


  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    "${var.node_group_name}" = {
      min_size     = var.min_capacity
      max_size     = var.max_capacity
      desired_size = var.desired_capacity
      instance_types = [var.instance_type]
    }
  }


  access_entries = {
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::730335218716:user/moshe-user"
      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }
}




