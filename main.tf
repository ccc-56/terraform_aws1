terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

resource "aws_network_interface" "test" {
  subnet_id   = "${var.sub_id}"
  private_ips = ["10.44.2.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "intest" {
  ami           = "ami-0756a1c858554433e"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
