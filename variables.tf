variable "region" {
  type = string
  default = "us-east-1"
}
variable "name" {
  type = string
  default = "JA"
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "maximum_capacity" {
  type    = number
  default = 5
}