terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
}

provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
  }
}

provider "kubectl" {
  host                   = module.eks_cluster.cluster_endpoint  # Correct reference to eks_cluster module
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token  # Consistent token reference
}
