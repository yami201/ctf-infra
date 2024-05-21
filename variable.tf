variable "vpc_cidr" {
  default = "10.0.0.0/20"
}

variable "subnet_count" {
  default = 8
}

variable "subnet_size" {
  default = 16
}

variable "attack-ami" {
  default = "ami-0aeb629f9535afbe0"
}
variable "target-ami" {
  default = "ami-022f69fb0aeae2ca7"
}
