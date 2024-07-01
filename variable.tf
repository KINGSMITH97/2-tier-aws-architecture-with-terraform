variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "CLEST_VPC"
}

variable "subnet1_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet1_name" {
  default = "pb_subnet_1"
}

variable "subnet2_cidr" {
  default = "10.0.2.0/24"
}

variable "subnet2_name" {
  default = "pb_subnet_2"
}

variable "internet_gateway" {
  default = "CLEST_igw"
}

variable "pb_RTB" {
  default = "pb_RTB"
}

variable "public_internet" {
  default = "0.0.0.0/0"
}

variable "pb_SG" {
  default = "pb_SG"
}

variable "sg_description" {
  default = "Allow ssh and http traffics on port 22 and 80 respectively"
}

variable "inboud" {
  default = "ingress"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "webServer1" {
  default = "webServer1"
}

variable "webServer2" {
  default = "webServer2"
}

variable "ami_id" {
  default = "ami-04b70fa74e45c3917"
}
