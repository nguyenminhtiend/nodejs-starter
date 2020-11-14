variable "cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  //default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "tags" {
}
