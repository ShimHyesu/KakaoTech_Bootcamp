provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
  cidr_block = "192.166.0.0/16"

  tags = {
    Name = "bunch_dev_vpc"
  }
}



# Subnet
resource "aws_subnet" "subnet_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.166.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "bunch_dev_subnet_2a_public"
  }
}

resource "aws_subnet" "subnet_2c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.166.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "bunch_dev_subnet_2c_public"
  }
}



# Public Route
resource "aws_internet_gateway" "igw_public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "bunch_dev_igw_public"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_public.id
  }

  tags = {
    Name = "bunch_dev_rtb_public"
  }
}

resource "aws_route_table_association" "rtb_association_public_2a" {
  subnet_id      = aws_subnet.subnet_2a.id
  route_table_id = aws_route_table.rtb_public.id
}
resource "aws_route_table_association" "rtb_association_public_2c" {
  subnet_id      = aws_subnet.subnet_2c.id
  route_table_id = aws_route_table.rtb_public.id
}



# Security Group 
resource "aws_security_group" "sg" {
  name        = "bunch_dev_sg"
  description = "Security group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # ping - 모든 ICMP, 내 VPC
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["192.166.0.0/16"] 
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_kafka" {
  name        = "bunch_dev_sg_kafka"
  description = "Security group for Kafka"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # ping - 모든 ICMP, 내 VPC
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["192.166.0.0/16"] 
  }

  ingress { # kafka
    from_port = 19092
    to_port = 19092
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # kafka-ui
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_elk" {
  name        = "bunch_dev_sg_elk"
  description = "Security group for ELK" 
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # ping - 모든 ICMP, 내 VPC
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["192.166.0.0/16"] 
  }

  ingress { # elasticsearch
    from_port = 9200
    to_port = 9200
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # logstash
    from_port = 5044
    to_port = 5044
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # kibana
    from_port = 5601
    to_port = 5601
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_db" {
  name        = "bunch_dev_sg_db"
  description = "Security group for DB"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # ping - 모든 ICMP, 내 VPC
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["192.166.0.0/16"] 
  }

  ingress { # mariadb
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





# EC2 Instance
resource "aws_instance" "server_instance" {
  ami           = "ami-045f2d6eeb07ce8c0" # amazon linux
  instance_type = "t3.medium"
  key_name      = "bunch-key"
  subnet_id     = aws_subnet.subnet_2a.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "bunch_dev_server_instance"
  }
}

resource "aws_instance" "mariadb_instance" {
  ami           = "ami-045f2d6eeb07ce8c0" # amazon linux
  instance_type = "t3.medium"
  key_name      = "bunch-key"
  subnet_id     = aws_subnet.subnet_2c.id
  vpc_security_group_ids = [aws_security_group.sg_db.id]

  tags = {
    Name = "bunch_dev_mariadb_instance"
  }
}

resource "aws_instance" "kafka_instance" {
  ami           = "ami-045f2d6eeb07ce8c0" # amazon linux
  instance_type = "t3.large"
  key_name      = "bunch-key"
  subnet_id     = aws_subnet.subnet_2a.id
  vpc_security_group_ids = [aws_security_group.sg_kafka.id]

  tags = {
    Name = "bunch_dev_kafka_instance"
  }
}

resource "aws_instance" "elk_instance" {
  ami           = "ami-045f2d6eeb07ce8c0" # amazon linux
  instance_type = "m5.large"
  key_name      = "bunch-key"
  subnet_id     = aws_subnet.subnet_2c.id
  vpc_security_group_ids = [aws_security_group.sg_elk.id]
  
  root_block_device {
    volume_size = 20  # 루트 볼륨 크기를 20GB로 설정
    volume_type = "gp3"
  }

  tags = {
    Name = "bunch_dev_elk_instance"
  }
}