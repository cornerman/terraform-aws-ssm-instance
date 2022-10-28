locals {
  cloudinit_config = <<EOF
Content-Type: multipart/mixed; boundary="MIMEBOUNDARY"
MIME-Version: 1.0

--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: text/x-shellscript
Mime-Version: 1.0

${var.cloudinit_shellscript}
EOF
}

data "aws_subnet" "subnet" {
  id = var.subnet_id
}

data "aws_ami" "amazon2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_security_group" "instance" {
  count  = var.egress_everywhere ? 1 : 0
  name   = "${var.name_prefix}-instance"
  vpc_id = data.aws_subnet.subnet.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_iam_role" "instance" {
  name = "${var.name_prefix}-instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm-attach" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "extra-attach" {
  for_each   = toset(var.extra_iam_policies)
  role       = aws_iam_role.instance.name
  policy_arn = each.key
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.name_prefix}-instance"
  role = aws_iam_role.instance.name
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.amazon2.id
  instance_type = var.instance_type

  user_data              = local.cloudinit_config
  iam_instance_profile   = aws_iam_instance_profile.instance.id
  subnet_id              = data.aws_subnet.subnet.id
  vpc_security_group_ids = concat(aws_security_group.instance.*.id, var.extra_security_groups)

  root_block_device {
    volume_size = var.root_volume_size_gb
  }

  tags = {
    Name = "${var.name_prefix}-instance"
  }
}
