
variable "cluster_name" {
  description = "Name of the EKS cluster."
  default     = "moshe-cluster"
}

variable "node_group_name" {
  description = "Name of the EKS node group."
  default     = "moshe-nodegroup"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "subnet_ids" {
  description = "The IDs of the existing subnets to be used for the EKS cluster."
  type        = list(string)
  default     = ["subnet-0337772ced879389e", "subnet-0b9a6dc9df9cea73e"]
}

variable "subnet_names" {
  description = "The names of the subnets."
  type        = list(string)
  default     = ["moshe-subnet-1" ,"moshe-subnet-2"]  
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be created."
  type        = string
  default     = "vpc-01b834daa2d67cdaa"
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.29"
}

variable "instance_type" {
  description = "The instance type for the EKS node group."
  type        = string
  default     =  "t2.micro"
}

variable "desired_capacity" {
  description = "Desired number of instances in the node group."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of instances in the node group."
  type        = number
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of instances in the node group."
  type        = number
  default     = 1
}

variable "iam_user_arn" {
  description = "IAM user ARN to grant access to the EKS cluster."
  type        = string
  default     = "arn:aws:iam::730335218716:user/moshe-user"
}

variable "hosted_zone_id" {
  description = "The Route 53 hosted zone ID."
  default = "Z00269823B8KU0UBQVXPI"
}

variable "domain_name" {
  description = "The domain name for the Route 53 record."
  default     = "wix-devops-workshop.com"
}

variable "load_balancer_dns" {
  description = "DNS name of the load balancer to associate with the Route 53 record."
  default     = "a917d1f098cee41439add80a989f3b4b-8def16401949fa6f.elb.eu-west-1.amazonaws.com"
}
