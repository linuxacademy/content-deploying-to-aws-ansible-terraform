// By defining these outputs, you can obtain resource values after deploying the infrastructure by executing the "terraform output" command in the console

// stores ids for amis to be used for spinning up EC2 instances in each respective region 
output "amiId-us-east-1" {
  value = data.aws_ssm_parameter.linuxAmi.value
}

output "amiId-us-west-2" {
  value = data.aws_ssm_parameter.linuxAmiOregon.value
}

//provides output of main jenkins server through retriving public and private addresses of of the EC2 instance named "jenkins-master"
output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}
output "Jenkins-Main-Node-Private-IP" {
  value = aws_instance.jenkins-master.private_ip
}
output "Jenkins-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.jenkins-worker-oregon :
    instance.id => instance.public_ip
  }
}
output "Jenkins-Worker-Private-IPs" {
  value = {
    for instance in aws_instance.jenkins-worker-oregon :
    instance.id => instance.private_ip
  }
}
// retrieves the fully qualified domain name of of an AWS ROUTE 53 record named Jenkins. This output provides the url that can be used to access the Jenkins server.
output "url" {
  value = aws_route53_record.jenkins.fqdn
}
