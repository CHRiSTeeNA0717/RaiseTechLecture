# declare variables used for prod-env

variable "name" {
  type        = string
  description = "The prefix name for resources"
}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "launch_template" {
  type = string
}
