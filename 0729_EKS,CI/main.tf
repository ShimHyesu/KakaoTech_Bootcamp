provider "aws" {
  region = "ap-northeast-2"
}

variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t3.medium"
}

resource "aws_vpc" "main" {
  cidr_block = "192.169.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.169.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet-2a"
  }
}

resource "aws_subnet" "main_2c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.169.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet-2c"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "main_2a" {
  subnet_id      = aws_subnet.main_2a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "main_2c" {
  subnet_id      = aws_subnet.main_2c.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "ami-062cf18d655c0b1e8"
  instance_type = var.instance_type
  key_name      = "ktb_key"
  subnet_id     = element([aws_subnet.main_2a.id, aws_subnet.main_2c.id], count.index % 2)
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "jenkins-${count.index}"
  }
}

output "instance_ips" {
  value = aws_instance.web.*.public_ip
}