output "Jenkins-Master-AMI-ID" {
  value = data.aws_ssm_parameter.JenkinsMasterAmi.value
}

output "Jenkins-Worker-AMI-ID" {
  value = data.aws_ssm_parameter.JenkinsWorkerAmi.value
}
output "privateIp-us-east-1" {
  value = aws_instance.jenkins-master.private_ip
}
output "publicIps-us-west-2" {
  value = {
    for instance in aws_instance.jenkins-worker :
    instance.id => instance.public_ip
  }
}
output "privateIps-us-west-2" {
  value = {
    for instance in aws_instance.jenkins-worker :
    instance.id => instance.private_ip
  }
}

output "Loadbalancer-DNS" {
  value = aws_lb.application-lb.dns_name
}
