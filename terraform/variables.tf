variable "region" {
  default = "ap-southeast-1"
}

variable "log_group" {
  default = "/ecs/nodejs-starter"
}

variable "container_name" {
  default = "nodejs-starter"
}

variable "account_id" {
  default = "621567429603"
}

variable "tags" {
}

variable "image" {
  default = "621567429603"
}

variable "desired_count" {
  default = 1
}
