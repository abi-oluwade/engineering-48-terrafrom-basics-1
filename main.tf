# Set a provider
provider "aws" {
  region  = "eu-west-1"
}

# Create VPC
resource "aws_vpc" "app_vpc" {
  cidr_block    = "10.0.0.0/16"
  tags    = {
    Name = var.Name
  }
}

# Create an IGW
resource "aws_internet_gateway" "app_igw" {
  vpc_id = "${aws_vpc.app_vpc.id}"

  tags = {
    Name = "${var.Name} - internet gateway"
  }
}

# Create a Route Table
resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
  tags = {
    Name = "${var.Name} - Route Table"
  }
}

# Create RT associations
resource  "aws_route_table_association" "app_assoc" {
  subnet_id  = "aws_subnet.app_subnet.id"
  route_table_id = "aws_route_table.app_route_table.id"
}

# Create a subnet
resource "aws_subnet" "app_subnet" {
  vpc_id    = "${aws_vpc.app_vpc.id}"
  cidr_block    = "10.0.0.0/24"
  availability_zone   = "eu-west-1a"
  tags    = {
    Name = var.Name
  }
}

# Create a security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.app_vpc.id}"


  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.Name
  }
}


# Send template sh file
data "template_file" "app_init" {
  template = "${file("./scripts/scripts.sh.tpl")}"
}

# Launch an instance
resource "aws_instance" "app_instance" {
  ami   = var.AMI_ID
  subnet_id   = "${aws_subnet.app_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  instance_type   = "t2.micro"
  associate_public_ip_address   = true
  user_data = data.template_file.app_init.rendered
  tags =  {
    Name = var.Name
  }
}
