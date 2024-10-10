 variable "vpc_id" {
  description = "The ID of the VPC where the subnets will be created."
  type        = string
  default     = "vpc-01b834daa2d67cdaa"  
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "192.168.10.0/24" 
}

# Define a list of CIDR blocks
variable "cidr_blocks" {
  description = "List of CIDR blocks for subnets."
  type        = list(string)
  default     = ["192.168.10.0/24", "192.168.11.0/24"]
}

# Define a list of availability zones
variable "availability_zones" {
  description = "The availability zones for the subnets."
  type        = list(string)
  default     = ["eu-west-1a" , "eu-west-1b"]      
}

variable "subnet_names" {
  description = "The names of the subnets."
  type        = list(string)
  default     = ["moshe-subnet-1" ,"moshe-subnet-2"]  
}

variable "name_bucket" {
  description = "The name of S3 bucket"
  type        = string
  default     = "moshe-bucket-s3"
}