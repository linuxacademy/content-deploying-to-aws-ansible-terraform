variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "site-name" {
  type    = string
  default = "mysite"
}
variable "dns-name" {
  type    = string
  default = "<insert-domain-name-ending-with-dot>" # e.g "cmcloudlab1234.info."
}

variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}
