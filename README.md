# ssm-instance

Terraform Module to setup a plain ec2 instance with ssm.
Uses the latest Amazon Linux 2 AMI for the instance.

Example:
```terraform
module "proxy_us" {
  source = "cornerman/ssm-instance/aws"
  version = "0.1.0"

  name_prefix = "my-server"
  vpc_id      = "..."
  subnet_id   = "..."

  # egress_everywhere     = true
  # instance_type         = "t3.micro"
  # root_volume_size_gb   = 20
  # extra_security_groups = [ "..." ]
  # extra_iam_policies    = [ "..." ]
  # cloudinit_shellscrpt  = file("./init.sh")
}
```
