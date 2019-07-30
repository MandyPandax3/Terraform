##RESOURCES FOR HULK - VPC, IGW, SUBNETS, SERVERS

provider "aws" {
    region = "us-east-1"
}
resource "aws_vpc" "hulk" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "hulk"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.hulk.id}"

  tags {
    Name = "hulk-igw"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id = "${aws_vpc.hulk.id}"
  cidr_block = "${var.public_subnet_cidr1}"
  availability_zone = "us-east-1a"

  tags {
    Name = "hulk_pub_01"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_subnet" "public-subnet2" {
  vpc_id = "${aws_vpc.hulk.id}"
  cidr_block = "${var.public_subnet_cidr2}"
  availability_zone = "us-east-1b"

  tags {
    Name = "hulk_pub_02"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_subnet" "public-subnet3" {
  vpc_id = "${aws_vpc.hulk.id}"
  cidr_block = "${var.public_subnet_cidr3}"
  availability_zone = "us-east-1c"

  tags {
    Name = "hulk_pub_03"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_subnet" "private-subnet1" {
  vpc_id = "${aws_vpc.hulk.id}"
  cidr_block = "${var.private_subnet_cidr1}"
  availability_zone = "us-east-1a"

  tags {
    Name = "hulk_priv_01"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_subnet" "private-subnet2" {
  vpc_id = "${aws_vpc.hulk.id}"
  cidr_block = "${var.private_subnet_cidr2}"
  availability_zone = "us-east-1b"

  tags {
    Name = "hulk_priv_02"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_subnet" "private-subnet3" {
  vpc_id = "${aws_vpc.hulk.id}"
  cidr_block = "${var.private_subnet_cidr3}"
  availability_zone = "us-east-1c"

  tags {
    Name = "hulk_priv_03"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}

#EIPs for NAT Gateways
resource "aws_eip" "nat1" {
  vpc = true

   tags {
    Name = "hulk_eip_nat1"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_eip" "nat2" {
  vpc = true

   tags {
    Name = "hulk_eip_nat2"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_eip" "nat3" {
  vpc = true

   tags {
    Name = "hulk_eip_nat3"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_nat_gateway" "nat1" {
  allocation_id = "${aws_eip.nat1.id}"
  subnet_id = "${aws_subnet.public-subnet1.id}"
  
   tags {
    Name = "hulk_nat_01"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_nat_gateway" "nat2" {
  allocation_id = "${aws_eip.nat2.id}"
  subnet_id = "${aws_subnet.public-subnet2.id}"
  
  tags {
    Name = "hulk_nat_02"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_nat_gateway" "nat3" {
  allocation_id = "${aws_eip.nat3.id}"
  subnet_id = "${aws_subnet.public-subnet3.id}"

  tags {
    Name = "hulk_nat_03"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}

#EIPs for Bastion Hosts
resource "aws_eip" "bastion1" {
  instance = "${aws_instance.bastion1.id}"
  vpc      = true

  tags {
    Name = "hulk_bastion1"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_eip" "bastion2" {
  instance = "${aws_instance.bastion2.id}"
  vpc      = true

  tags {
    Name = "hulk_bastion2"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_eip" "bastion3" {
  instance = "${aws_instance.bastion3.id}"
  vpc      = true

  tags {
    Name = "hulk_bastion3"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_eip_association" "eip_assoc1" {
  instance_id   = "${aws_instance.bastion01.id}"
  allocation_id = "${aws_eip.bastion1.id}"
}
resource "aws_eip_association" "eip_assoc2" {
  instance_id   = "${aws_instance.bastion02.id}"
  allocation_id = "${aws_eip.bastion2.id}"
}
resource "aws_eip_association" "eip_assoc3" {
  instance_id   = "${aws_instance.bastion03.id}"
  allocation_id = "${aws_eip.bastion3.id}"
}

resource "aws_instance" "bastion01" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet1.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  key_name = "hulk-2019"

  tags {
    Name = "bastion_01"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_instance" "bastion02" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet2.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  key_name = "hulk-2019"

   tags {
    Name = "bastion_02"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_instance" "bastion03" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet3.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  key_name = "hulk-2019"

   tags {
    Name = "bastion_03"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}

resource "aws_alb" "web" {
  name            = "hulk-web-alb"
  internal = false
  idle_timeout = "300"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${aws_subnet.public-subnet1.*.id}", "${aws_subnet.public-subnet2.*.id}", "${aws_subnet.public-subnet3.*.id}" ]
  enable_deletion_protection = true

  tags {
    Name = "hulk-web-alb"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_alb_target_group" "web" {
  name     = "hulk-alb-target"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${aws_vpc.hulk.id}"
 
  health_check {
    path = "/health_check"
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 5
    interval = 30
  }

    tags {
    Name = "hulk_tg"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_alb_listener" "listener_http_web" {
  load_balancer_arn = "${aws_alb.web.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type            = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener_rule" "redirect_v2_to_api" {
  listener_arn = "${aws_alb_listener.listener_http_web.arn}"
  action {    
      type             = "forward"    
      target_group_arn = "${aws_alb_target_group.web.arn}"
    }   
    condition {    
     field  = "path-pattern"      
     values = ["/v2/*"]
     }
  } 
resource "aws_alb_listener" "listener_https_web" {
  load_balancer_arn = "${aws_alb.web.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${aws_acm_certificate.hulk.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.web.arn}"
    type             = "forward"
  }
}

resource "aws_alb" "api" {
  name            = "hulk-api"
  internal = false
  idle_timeout = "300"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${aws_subnet.public-subnet1.*.id}", "${aws_subnet.public-subnet2.*.id}", "${aws_subnet.public-subnet3.*.id}" ]
  enable_deletion_protection = true

  tags {
    Name = "hulk-alb-api"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_alb_target_group" "api" {
  name     = "hulk-alb-api-target"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${aws_vpc.hulk.id}"
 
  health_check {
    path = "/health_check"
    healthy_threshold = 3 
    unhealthy_threshold = 10
    timeout = 5
    interval = 30
  }

   tags {
    Name = "hulk_api_tg"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_alb_listener" "listener_http_api" {
  load_balancer_arn = "${aws_alb.api.arn}"
  port              = "80"
  protocol          = "HTTP"

default_action {
    type             = "redirect"

      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
    }
  }
}
resource "aws_alb_listener" "listener_https_api" {
  load_balancer_arn = "${aws_alb.api.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${aws_acm_certificate.hulk.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.api.arn}"
    type             = "forward"
  }
}

#TG for Jobs necessary for ASG creation
resource "aws_alb_target_group" "jobs" {
  name     = "hulk-tg-jobs"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${aws_vpc.hulk.id}"
 
  health_check {
    path = "/health_check"
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 5
    interval = 30
  }

   tags {
    Name = "hulk_jobs_tg"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}

resource "aws_alb_target_group" "bastion" {
  name     = "hulk-alb-bastion-target"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${aws_vpc.hulk.id}"
 
  health_check {
    path = "/health_check"
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 5
    interval = 30
  }

    tags {
    Name = "hulk_bastion_tg"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}

resource "aws_alb_target_group_attachment" "bastion1" {
  target_group_arn = "${aws_alb_target_group.bastion.arn}"
  target_id        = "${aws_instance.bastion01.id}"
}
resource "aws_alb_target_group_attachment" "bastion2" {
  target_group_arn = "${aws_alb_target_group.bastion.arn}"
  target_id        = "${aws_instance.bastion02.id}"
}
resource "aws_alb_target_group_attachment" "bastion3" {
target_group_arn = "${aws_alb_target_group.bastion.arn}"
  target_id        = "${aws_instance.bastion03.id}"
}

 
resource "aws_launch_configuration" "web" {
  name = "web_launch_config"
  image_id = "${var.ami-api-web}"
  instance_type = "c5.2xlarge"
  iam_instance_profile = "${aws_iam_instance_profile.ec2-full-access.name}"
  key_name = "hulk-2019"
  security_groups = ["${aws_security_group.sgpriv.id}", "${aws_security_group.efs_mount.id}"]
  # user_data = 
  root_block_device {
        volume_type = "gp2"
        volume_size = 20
  }
}
resource "aws_autoscaling_group" "web" {
  desired_capacity   = 3
  max_size           = 5
  min_size           = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = false
  vpc_zone_identifier = ["${aws_subnet.private-subnet1.id}", "${aws_subnet.private-subnet2.id}", "${aws_subnet.private-subnet3.id}"]
  target_group_arns = ["${aws_alb_target_group.web.arn}"]
  launch_configuration = "${aws_launch_configuration.web.id}"
  
  tags {
   key = "name"
   value = "hulk_web_asg"
   propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "api" {
  name = "api_launch_config"
  image_id = "${var.ami-api-web}"
  instance_type = "c5.2xlarge"
  iam_instance_profile = "${aws_iam_instance_profile.ec2-full-access.name}"
  key_name = "hulk-2019"
  security_groups = ["${aws_security_group.sgpriv.id}", "${aws_security_group.efs_mount.id}"]
  root_block_device {
        volume_type = "gp2"
        volume_size = 20
  }
}
resource "aws_autoscaling_group" "api" {
  desired_capacity   = 3
  max_size           = 6
  min_size           = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = false
  vpc_zone_identifier = ["${aws_subnet.private-subnet1.id}", "${aws_subnet.private-subnet2.id}", "${aws_subnet.private-subnet3.id}"]
  target_group_arns = ["${aws_alb_target_group.api.arn}"]
  launch_configuration = "${aws_launch_configuration.api.id}"

  tags {
    key = "name"
    value = "api_asg"
    propagate_at_launch = true
  }
}

 resource "aws_launch_configuration" "jobs" {
  name = "jobs_launch_config"
  image_id = "${var.ami-jobs}"
  instance_type = "c5.2xlarge"
  iam_instance_profile = "${aws_iam_instance_profile.ec2-full-access.name}"
  key_name = "hulk-2019"
  security_groups = ["${aws_security_group.sgpriv.id}", "${aws_security_group.efs_mount.id}"]
  root_block_device {
        volume_type = "gp2"
        volume_size = 20
  }
}
resource "aws_autoscaling_group" "jobs" {
  desired_capacity   = 3
  max_size           = 4
  min_size           = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = false
  vpc_zone_identifier = ["${aws_subnet.private-subnet1.id}", "${aws_subnet.private-subnet2.id}", "${aws_subnet.private-subnet3.id}"]
  target_group_arns = ["${aws_alb_target_group.jobs.arn}"]
  launch_configuration = "${aws_launch_configuration.jobs.id}"
  
  tags {
    key = "name"
    value = "jobs_asg"
    propagate_at_launch = true
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.hulk.id}"
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_efs_file_system" "hulk" {
  creation_token = "my-efs-hulk"
  kms_key_id = "${aws_kms_key.hulk.arn}" 
  encrypted = true

  tags {
    Name = "hulk-efs-tf"
    Environment = "Production"
    Region = "Us-East-01"
    Phase = "01"
  }
}
resource "aws_efs_mount_target" "privsubnet1" {
  file_system_id = "${aws_efs_file_system.hulk.id}"
  subnet_id      = "${aws_subnet.private-subnet1.id}"
  security_groups = ["${aws_security_group.efs_mount.id}"]
}
resource "aws_efs_mount_target" "privsubnet2" {
  file_system_id = "${aws_efs_file_system.hulk.id}"
  subnet_id      = "${aws_subnet.private-subnet2.id}"
  security_groups = ["${aws_security_group.efs_mount.id}"]
}
resource "aws_efs_mount_target" "privsubnet3" {
  file_system_id = "${aws_efs_file_system.hulk.id}"
  subnet_id      = "${aws_subnet.private-subnet3.id}"
  security_groups = ["${aws_security_group.efs_mount.id}"]
}

