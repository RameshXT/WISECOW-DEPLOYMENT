# AWS VARIABLE
variable "region" {
  default = "us-east-1"
}

# AWS EC2 INSTANCE VARIABLES
variable "key_pair_name" {
  default = "Primary"
}

variable "security_group_name" {
  default = "Primary-SG"
}

variable "volume_size" {
  default = 30
}

variable "instance_name" {
  default = "WiseCow"
}

variable "instance_type" {
  default = "t3.large"
}
