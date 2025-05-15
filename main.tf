## AMI for EC2 ##
data "aws_ami" "devops2502_ubuntu_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

/*
data "aws_ami" "devops2502_amazonlinux_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["234139188789"] # Canonical
}

data "aws_ami" "devops2502_debian_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["234139188789"] # Canonical
}
*/

## EC2 Instance
resource "aws_instance" "devops2502-ec2-public" {
  ami = data.aws_ami.devops2502_ubuntu_ami.id   # output = ami-0e4c4dc2f1277acca
  instance_type = "t2.micro"
  subnet_id = aws_subnet.devops2502-sn-public-1.id

  tags = {
    Name = "vti-do2502-DE000028-ec2-public-ew3-001"
  }
}

/*
resource "aws_instance" "devops2502-ec2-private" {
  ami = data.aws_ami.devops2502_ubuntu_ami.id   # output = ami-0e4c4dc2f1277acca
  instance_type = "t2.micro"
  subnet_id = aws_subnet.devops2502-sn-private-1.id

  tags = {
    Name = "vti-do2502-DE000028-ec2-private-ew3-001"
  }
}

resource "aws_instance" "devops2502-ec2-database" {
  ami = data.aws_ami.devops2502_ubuntu_ami.id   # output = ami-0e4c4dc2f1277acca
  instance_type = "t2.micro"
  subnet_id = aws_subnet.devops2502-sn-database-1.id

  tags = {
    Name = "vti-do2502-DE000028-ec2-database-ew3-001"
  }
}
*/


## Key pair ##
# Generate private key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair in AWS using public key
resource "aws_key_pair" "devops2502_keypair" {
  key_name   = "vti-do2502-DE000028-kp-public-ew3-001"
  public_key = tls_private_key.key.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}



## Create a VPC ##
resource "aws_vpc" "devops2502-vpc" {
  cidr_block = "10.11.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "vti-do2502-DE000028-vpc-ew3-001"
  }
}


## Subnet ##
resource "aws_subnet" "devops2502-sn-public-1" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.2.0/24"
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true    # Auto assign public IP

  tags = {
    Name = "vti-do2502-DE000028-sn-public-ew3-001"
  }
}

/*
resource "aws_subnet" "devops2502-sn-public-2" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.3.0/24"
  availability_zone       = var.availability_zone[1]

  tags = {
    Name = "vti-do2502-DE000028-sn-public-ew3-002"
  }
}

resource "aws_subnet" "devops2502-sn-public-3" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.4.0/24"
  availability_zone       = var.availability_zone[2]

  tags = {
    Name = "vti-do2502-DE000028-sn-public-ew3-003"
  }
}

resource "aws_subnet" "devops2502-sn-private-1" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.11.0/24"
  availability_zone       = var.availability_zone[0]

  tags = {
    Name = "vti-do2502-DE000028-sn-private-ew3-001"
  }
}

resource "aws_subnet" "devops2502-sn-private-2" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.12.0/24"
  availability_zone       = var.availability_zone[1]

  tags = {
    Name = "vti-do2502-DE000028-sn-private-ew3-002"
  }
}

resource "aws_subnet" "devops2502-sn-private-3" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.13.0/24"
  availability_zone       = var.availability_zone[2]

  tags = {
    Name = "vti-do2502-DE000028-sn-private-ew3-003"
  }
}

resource "aws_subnet" "devops2502-sn-database-1" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.20.0/24"
  availability_zone       = var.availability_zone[0]

  tags = {
    Name = "vti-do2502-DE000028-sn-database-ew3-001"
  }
}

resource "aws_subnet" "devops2502-sn-database-2" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.21.0/24"
  availability_zone       = var.availability_zone[1]

  tags = {
    Name = "vti-do2502-DE000028-sn-database-ew3-002"
  }
}
*/

## Internet Gateway ##
resource "aws_internet_gateway" "devops2502_igw" {
  vpc_id = aws_vpc.devops2502-vpc.id

  tags = {
    Name = "vti-do2502-DE000028-igw-ew3-001"
  }
}

output "public_ec2_ip" {
  value = aws_instance.devops2502-ec2-public.public_ip
}

## Route table ##
resource "aws_route_table" "devops2502_rtb_public" {
  vpc_id = aws_vpc.devops2502-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops2502_igw.id
  }

  tags = {
    Name = "vti-do2502-DE000028-rtb-public-ew3-001"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.devops2502-sn-public-1.id
  route_table_id = aws_route_table.devops2502_rtb_public.id
}