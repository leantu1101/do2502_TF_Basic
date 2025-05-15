########## VPC ##########

resource "aws_vpc" "devops2502-vpc" {
  cidr_block = "10.11.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "vti-do2502-DE000028-vpc-ew3-001"
  }
}


########## SUBNET ##########

resource "aws_subnet" "devops2502-sn-public-1" {
  vpc_id                  = aws_vpc.devops2502-vpc.id
  cidr_block              = "10.11.2.0/24"
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true    # Auto assign public IP

  tags = {
    Name = "vti-do2502-DE000028-sn-public-ew3-001"
  }
}

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


########## SECURITY GROUP ##########

# For Public subnet
resource "aws_security_group" "devops2502_securitygroup_forPublic" {
  name        = "vti-do2502-DE000028-sg-public-ew3-001"
  description = "Public SG"
  vpc_id      = aws_vpc.devops2502-vpc.id

  tags = {
    Name = "vti-do2502-DE000028-sg-public-ew3-001"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_forPublic" {
  security_group_id = aws_security_group.devops2502_securitygroup_forPublic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ipv4_forPublic" {
  security_group_id = aws_security_group.devops2502_securitygroup_forPublic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"    # semantically equivalent to all ports
  description       = "Allow all traffic from any"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_forPublic" {
  security_group_id = aws_security_group.devops2502_securitygroup_forPublic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic from Public SG"
}

# For Private subnet
resource "aws_security_group" "devops2502_securitygroup_forPrivate" {
  name        = "vti-do2502-DE000028-sg-private-ew3-001"
  description = "Private SG"
  vpc_id      = aws_vpc.devops2502-vpc.id

  tags = {
    Name = "vti-do2502-DE000028-sg-private-ew3-001"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_forPrivate" {
  security_group_id = aws_security_group.devops2502_securitygroup_forPrivate.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ipv4_forPrivate" {
  security_group_id            = aws_security_group.devops2502_securitygroup_forPrivate.id
  referenced_security_group_id = aws_security_group.devops2502_securitygroup_forPublic.id
  ip_protocol                  = "-1"    # semantically equivalent to all ports
  description                  = "Allow all traffic from Public SG"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_forPrivate" {
  security_group_id = aws_security_group.devops2502_securitygroup_forPrivate.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic from Private SG"
}

# For Database subnet
resource "aws_security_group" "devops2502_securitygroup_forDatabase" {
  name        = "vti-do2502-DE000028-sg-database-ew3-001"
  description = "Database SG"
  vpc_id      = aws_vpc.devops2502-vpc.id

  tags = {
    Name = "vti-do2502-DE000028-sg-database-ew3-001"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_forDatabase" {
  security_group_id = aws_security_group.devops2502_securitygroup_forDatabase.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ipv4_forDatabase" {
  security_group_id            = aws_security_group.devops2502_securitygroup_forDatabase.id
  referenced_security_group_id = aws_security_group.devops2502_securitygroup_forPublic.id
  ip_protocol                  = "-1"          # semantically equivalent to all ports
  description                  = "Allow all traffic from Public SG"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_forDatabase" {
  security_group_id = aws_security_group.devops2502_securitygroup_forDatabase.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic from Database SG"
}

########## INTERNET GATEWAY ##########

resource "aws_internet_gateway" "devops2502_igw" {
  vpc_id = aws_vpc.devops2502-vpc.id

  tags = {
    Name = "vti-do2502-DE000028-igw-ew3-001"
  }
}


########## ROUTE TABLE ##########

# Route table for Public Subnet
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

resource "aws_route_table_association" "subnet_association_forPublic" {
  for_each = {
    subnet1 = aws_subnet.devops2502-sn-public-1.id,
    subnet2 = aws_subnet.devops2502-sn-public-2.id,
    subnet3 = aws_subnet.devops2502-sn-public-3.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.devops2502_rtb_public.id
}

# Route table for Private Subnet
resource "aws_route_table" "devops2502_rtb_private" {
  vpc_id = aws_vpc.devops2502-vpc.id

  tags = {
    Name = "vti-do2502-DE000028-rtb-public-ew3-001"
  }
}

resource "aws_route_table_association" "subnet_association_forPrivate" {
  for_each = {
    subnet1 = aws_subnet.devops2502-sn-private-1.id,
    subnet2 = aws_subnet.devops2502-sn-private-2.id,
    subnet3 = aws_subnet.devops2502-sn-private-3.id,
    subnet4 = aws_subnet.devops2502-sn-database-1.id,
    subnet5 = aws_subnet.devops2502-sn-database-2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.devops2502_rtb_private.id
}


########## KEY PAIR ##########

# Generate private key
resource "tls_private_key" "key_forPublic" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "key_forPrivate" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair in AWS using public key
resource "aws_key_pair" "devops2502_keypair_forPublic" {
  key_name   = "vti-do2502-DE000028-kp-public-ew3-001"
  public_key = tls_private_key.key_forPublic.public_key_openssh
}

resource "aws_key_pair" "devops2502_keypair_forPrivate" {
  key_name   = "vti-do2502-DE000028-kp-private-ew3-001"
  public_key = tls_private_key.key_forPrivate.public_key_openssh
}

# Save private key by file PEM in Windows
resource "local_file" "private_key_pem_forPublic" {
  content          = tls_private_key.key_forPublic.private_key_pem
  filename         = "D:/Tuan_Docs/DO2502/vti-do2502-DE000028-kp-public-ew3-001.pem"
  file_permission  = "0600"
}

resource "local_file" "private_key_pem_forPrivate" {
  content          = tls_private_key.key_forPrivate.private_key_pem
  filename         = "D:/Tuan_Docs/DO2502/vti-do2502-DE000028-kp-private-ew3-001.pem"
  file_permission  = "0600"
}


########## AMI ##########

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

data "aws_ami" "devops2502_amazonlinux_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon Linux
}

data "aws_ami" "devops2502_debian_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"] # Debian
}


########## EC2 INSTANCE ###########

resource "aws_instance" "devops2502-ec2-public" {
  ami = data.aws_ami.devops2502_ubuntu_ami.id   # output = ami-0e4c4dc2f1277acca
  instance_type = "t2.micro"
  subnet_id = aws_subnet.devops2502-sn-public-1.id
  vpc_security_group_ids = [aws_security_group.devops2502_securitygroup_forPublic.id]
  key_name = "vti-do2502-DE000028-kp-public-ew3-001"

  tags = {
    Name = "vti-do2502-DE000028-ec2-public-ew3-001"
  }
}

resource "aws_instance" "devops2502-ec2-private" {
  ami = data.aws_ami.devops2502_amazonlinux_ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.devops2502-sn-private-1.id
  vpc_security_group_ids = [aws_security_group.devops2502_securitygroup_forPrivate.id]
  key_name = "vti-do2502-DE000028-kp-private-ew3-001"

  tags = {
    Name = "vti-do2502-DE000028-ec2-private-ew3-001"
  }
}

resource "aws_instance" "devops2502-ec2-database" {
  ami = data.aws_ami.devops2502_debian_ami.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.devops2502-sn-database-1.id
  vpc_security_group_ids = [aws_security_group.devops2502_securitygroup_forDatabase.id]
  key_name = "vti-do2502-DE000028-kp-private-ew3-001"

  tags = {
    Name = "vti-do2502-DE000028-ec2-database-ew3-001"
  }
}