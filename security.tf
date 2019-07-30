##SECURITY GROUPS, SSH ACCESS KEYS FOR BASTION HOSTS & POLICIES 

##security groups
resource "aws_security_group" "sgpubweb" {
  name = "public_sg"
  description = "Allow incoming HTTP/HTTPS connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3001
    to_port = 3001
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

 egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.hulk.id}"
}

resource "aws_security_group" "sgpriv"{
  name = "private_web"
  description = "Allow traffic from public subnets"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = ["${aws_security_group.sgpubweb.id}" ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr1}", "${var.public_subnet_cidr2}", "${var.public_subnet_cidr3}"]
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]
  }

  ingress {
      from_port = 3001
      to_port = 3001
      protocol = "tcp"
      cidr_blocks =  ["0.0.0.0/0"]
    }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.hulk.id}"
}

resource "aws_security_group" "bastion-sg" {
  name   = "bastion_sg"
  vpc_id = "${aws_vpc.hulk.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 3001
      to_port = 3001
      protocol = "tcp"
      cidr_blocks =  ["0.0.0.0/0"]
    }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs_mount" {
  name = "elasticfilesystem_sg"
  vpc_id = "${aws_vpc.hulk.id}"

  ingress {
    protocol = "tcp"
    from_port = 2049
    to_port = 2049
    cidr_blocks = ["${var.private_subnet_cidr1}", "${var.private_subnet_cidr2}", "${var.private_subnet_cidr3}"]
    }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
   }
  }

  resource "aws_security_group" "alb" {
  name        = "applicationloadbalancer_sg"
  description = "Terraform load balancer security group"
  vpc_id      = "${aws_vpc.hulk.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
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
}
  
##service policies
resource"aws_iam_policy" "opsworks-s3" {
  name = "opsworks-s3-policy"
  description = "Provides Opsworks with access to S3"
  policy = "${file("/path/to/s3_opsworks.json")}"
}

resource "aws_iam_policy" "opsworks-policy" {
 name = "opsworks-policy"
 description = "Provides Opsworks necessary permissions to run"
 policy = "${file("/path/to/opsworkspolicy.json")}"
}

resource "aws_iam_policy" "rds-policy" {
 name = "rds-policy"
 description = "Provides full RDS permissions"
 policy = "${file("/path/to/rdsaccess.json")}"
}

resource "aws_iam_policy" "cw-policy" {
 name = "cloudwatch-policy"
 description = "Provides full CloudWatch permissions"
 policy = "${file("/path/to/cwaccess.json")}"
}

resource "aws_iam_policy" "ec2-policy" {
 name = "ec2-policy"
 description = "Provides full EC2 access permissions"
 policy = "${file("/path/to/ec2access.json")}"  
}

resource "aws_iam_policy" "es-policy" {
 name = "elasticsearch-policy"
 description = "Provides EC2 with necessary ElasticSearch permissions"
 policy = "${file("/path/to/esaccess.json")}" 
}

resource "aws_iam_policy" "redis-policy" {
 name = "redis-policy"
 description = "Provides EC2 with necessary Redis permissions"
 policy = "${file("/path/to/redisaccess.json")}"
}

#service roles

resource "aws_iam_role" "opsworks_access_role" {
    name = "Opsworks"
    assume_role_policy = "${file("/path/to/opsworkspolicy.json")}"
}

resource "aws_iam_role" "ec2_access_role" {
    name = "EC2"
    assume_role_policy = "${file("/path/to/assumerolepolicy.json")}"
}

#role attachments

resource "aws_iam_policy_attachment" "opsworks-attach" {
  name = "opsworks-s3-attachment"
  roles = ["${aws_iam_role.ec2_access_role.name}"]
  policy_arn = "${aws_iam_policy.opsworks-s3.arn}" 
}

resource "aws_iam_policy_attachment" "opsworks-profile" {
  name = "Opsworks-attachment"
  roles = ["${aws_iam_role.ec2_access_role.name}"]
  policy_arn = "${aws_iam_policy.opsworks-policy.arn}" 
}

resource "aws_iam_policy_attachment" "ec2-attach-01" {
  name = "RDS-attachment"
  roles = ["${aws_iam_role.ec2_access_role.name}"]
  policy_arn = "${aws_iam_policy.rds-policy.arn}" 
}

resource "aws_iam_policy_attachment" "ec2-attach-02" {
  name = "CW-attachment"
  roles = ["${aws_iam_role.ec2_access_role.name}"]
  policy_arn = "${aws_iam_policy.cw-policy.arn}" 
}

resource "aws_iam_policy_attachment" "ec2-attach-03" {
  name = "CW-attachment"
  roles = ["${aws_iam_role.ec2_access_role.name}"]
  policy_arn = "${aws_iam_policy.ec2-policy.arn}" 
}

resource "aws_iam_policy_attachment" "ec2-attach-04" {
  name = "ES-attachment"
  roles = ["${aws_iam_role.ec2_access_role.name}"]
  policy_arn = "${aws_iam_policy.es-policy.arn}" 
}

resource "aws_iam_policy_attachment" "ec2-attach-05" {
  name = "Redis-attachment"
  roles = ["${aws_iam_role.ec2_access_role.name}"]
  policy_arn = "${aws_iam_policy.redis-policy.arn}" 
}

#instance profiles

resource "aws_iam_instance_profile" "opsworks-profile" {
  name = "opsworks-instance-profile"
  role = "${aws_iam_role.opsworks_access_role.name}"
}

resource "aws_iam_instance_profile" "ec2-full-access" {
  name = "prod-instance-profile"
  role = "${aws_iam_role.ec2_access_role.name}"
}

#create KMS key
resource "aws_kms_key" "name" {
  description             = "Description"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

#create ACM certificate

resource "aws_acm_certificate" "test" {
  domain_name       = "*.domain.com"
  validation_method = "DNS"
}

#route53 record confirms domain ownership
data "aws_route53_zone" "external" {
  name = "domain.com"
}
resource "aws_route53_record" "validation" {
  name    = "${aws_acm_certificate.test.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.test.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.external.zone_id}"
  records = ["${aws_acm_certificate.test.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

#forces resource to wait for newly created certificate to become valid
resource "aws_acm_certificate_validation" "test" {
  certificate_arn = "${aws_acm_certificate.test.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.validation.fqdn}",
  ]
}
