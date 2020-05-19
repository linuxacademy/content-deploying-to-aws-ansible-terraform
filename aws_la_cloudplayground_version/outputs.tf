output "amiId-us-east-1" {
  value = data.aws_ssm_parameter.linuxAmi.value
}

output "amiId-us-west-2" {
  value = data.aws_ssm_parameter.linuxAmiOregon.value
}
output "publicIp-us-east-1" {
  value = aws_instance.jenkins-master.public_ip
}
output "privateIp-us-east-1" {
  value = aws_instance.jenkins-master.private_ip
}
output "publicIps-us-west-2" {
  value = {
    for instance in aws_instance.jenkins-worker-oregon :
    instance.id => instance.public_ip
  }
}
output "privateIps-us-west-2" {
  value = {
    for instance in aws_instance.jenkins-worker-oregon :
    instance.id => instance.private_ip
  }
}

output "url" {
  value = aws_route53_record.jenkins.fqdn
}
