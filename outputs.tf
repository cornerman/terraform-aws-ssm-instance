output "ssh_config" {
  value = <<EOT

# This should go into your ~/.ssh/config.
# Then you can use `ssh ${var.name_prefix}`.

Host ${var.name_prefix}
  HostName ${aws_instance.instance.id}
  User ec2-user
  ProxyCommand sh -c "aws --region ${data.aws_region.current.name} --profile <my-profile> ec2-instance-connect send-ssh-public-key --instance-id %h --instance-os-user %r --ssh-public-key 'file://~/.ssh/id_rsa.pub' --availability-zone '$(aws --region ${data.aws_region.current.name} --profile <my-profile> ec2 describe-instances --instance-ids %h --query 'Reservations[0].Instances[0].Placement.AvailabilityZone' --output text)' && aws --region ${data.aws_region.current.name} --profile <my-profile> ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
EOT
}
