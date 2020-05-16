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
output "publicIp-us-west-2" {
  value = aws_instance.jenkins-worker-oregon.public_ip
}
output "privateIp-us-west-2" {
  value = aws_instance.jenkins-worker-oregon.private_ip
}

output "url" {
  value = aws_route53_record.jenkins.fqdn
}
