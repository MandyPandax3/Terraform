
##VARIABLES FOR HULK TEMPLATE

#default region
variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

##CIDR blocks
variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr1" {
  description = "CIDR for the public subnet 1 "
  default = "10.0.156.0/24"
}

variable "public_subnet_cidr2" {
  description = "CIDR for the public subnet 2"
  default = "10.0.157.0/24"
}

variable "public_subnet_cidr3" {
  description = "CIDR for the public subnet 3"
  default = "10.0.158.0/24"
}

variable "private_subnet_cidr1" {
  description = "CIDR for the private subnet 1"
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr2" {
  description = "CIDR for the private subnet 2"
  default = "10.0.2.0/24"
}
variable "private_subnet_cidr3" {
  description = "CIDR for the private subnet 3"
  default = "10.0.3.0/24"
}


##default AMI ID

variable "ami" {
  description = "Bastion AMI"
  default = "i-aaaaaaaaazzzzzzzz"
}

variable "ami-api-web" {
  description = "Web & API AMI"
  default = "ami-aaaaaaaaazzzzzzzz"
}

variable "ami-jobs" {
  description = "Jobs AMI"
  default = "ami-aaaaaaaaazzzzzzzz"
}
