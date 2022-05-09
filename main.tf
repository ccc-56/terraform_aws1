resource "aws_subnet" "my_subnet" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "test" {
  subnet_id   = "${var.sub_id}"
  private_ips = ["10.44.2.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "intest" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
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
