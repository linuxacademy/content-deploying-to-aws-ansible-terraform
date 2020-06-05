output "url" {
  value = aws_route53_record.webservers.fqdn
}

output "Apache1" {
  value = data.aws_instance.apache1.public_ip
}
output "Apache2" {
  value = data.aws_instance.apache2.public_ip
}

output "Application-LB-URL" {
  value = aws_lb.application-lb.dns_name
}
