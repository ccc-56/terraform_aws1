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
  profile = "source"
}

resource "aws_network_interface" "test" {
  subnet_id   = "${var.sub_id}"
  private_ips = ["10.44.2.101"]

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

  tags = {
    Name = "HelloWorld1"
  }

}

resource "aws_db_subnet_group" "education" {
  name       = "education"
  subnet_ids = ["${var.subnet_db}","${var.subnet_db1}"]

  tags = {
    Name = "php-Education"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb1"
  username             = "foo1"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.education.name
}

