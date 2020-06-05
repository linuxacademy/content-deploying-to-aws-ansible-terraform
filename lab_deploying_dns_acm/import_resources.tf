provider "aws" {
  profile = var.profile
  region  = var.region-master
  alias   = "region-master"
}

data "aws_vpc" "vpc_master" {
  provider = aws.region-master

  id = "<INSERT-VALUE-HERE>"
}

data "aws_security_group" "security_group_lb" {
  provider = aws.region-master
  id       = "<INSERT-VALUE-HERE>"
}

data "aws_subnet" "subnet_1" {
  provider = aws.region-master

  id = "<INSERT-VALUE-HERE>"
}

data "aws_subnet" "subnet_2" {
  provider = aws.region-master

  id = "<INSERT-VALUE-HERE>"
}
data "aws_instance" "apache1" {
  provider    = aws.region-master
  instance_id = "<INSERT-VALUE-HERE>"
}
data "aws_instance" "apache2" {
  provider    = aws.region-master
  instance_id = "<INSERT-VALUE-HERE>"
}

