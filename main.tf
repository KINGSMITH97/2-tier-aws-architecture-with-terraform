resource "aws_vpc" "CLEST_VPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "pb_subnet-1" {
  vpc_id                  = aws_vpc.CLEST_VPC.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet1_name
  }
}

resource "aws_subnet" "pb_subnet-2" {
  vpc_id                  = aws_vpc.CLEST_VPC.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet2_name
  }
}

resource "aws_internet_gateway" "CLEST_igw" {
  vpc_id = aws_vpc.CLEST_VPC.id

  tags = {
    Name = var.internet_gateway
  }

}


resource "aws_route_table" "pb_RTB" {
  vpc_id = aws_vpc.CLEST_VPC.id

  route {
    cidr_block = var.public_internet
    gateway_id = aws_internet_gateway.CLEST_igw.id
  }

  tags = {
    Name = var.pb_RTB
  }

}

resource "aws_route_table_association" "rtb_association-1" {
  subnet_id      = aws_subnet.pb_subnet-1.id
  route_table_id = aws_route_table.pb_RTB.id
}

resource "aws_route_table_association" "rtb_association-2" {
  subnet_id      = aws_subnet.pb_subnet-2.id
  route_table_id = aws_route_table.pb_RTB.id
}

resource "aws_security_group" "pb_SG" {
  name        = var.pb_SG
  description = var.sg_description
  vpc_id      = aws_vpc.CLEST_VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.pb_SG
  }

}


resource "aws_instance" "webServer1" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.pb_subnet-1.id
  vpc_security_group_ids = [aws_security_group.pb_SG.id]

  user_data = base64encode(file("user_data1.sh"))

  tags = {
    Name = var.webServer1
  }
}

resource "aws_instance" "webServer2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.pb_subnet-2.id
  vpc_security_group_ids = [aws_security_group.pb_SG.id]

  user_data = base64encode(file("user_data2.sh"))

  tags = {
    Name = var.webServer2
  }
}

resource "aws_lb" "ClestALB" {
  name               = "ClestALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.pb_subnet-1.id, aws_subnet.pb_subnet-2.id]
  security_groups    = [aws_security_group.pb_SG.id]

  tags = {
    Name = "ClestALB"
  }

}

resource "aws_lb_target_group" "AlbTG" {
  name     = "AlbTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.CLEST_VPC.id

  health_check {
    port = "traffic-port"
    path = "/"
  }

  tags = {
    Name = "AlbTG"
  }

}

resource "aws_lb_target_group_attachment" "lbAttach1" {
  target_group_arn = aws_lb_target_group.AlbTG.arn
  target_id        = aws_instance.webServer1.id
  port             = 80

}

resource "aws_lb_target_group_attachment" "lbAttach2" {
  target_group_arn = aws_lb_target_group.AlbTG.arn
  target_id        = aws_instance.webServer2.id
  port             = 80

}

resource "aws_lb_listener" "Alb_listener" {
  load_balancer_arn = aws_lb.ClestALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.AlbTG.arn
  }

}
