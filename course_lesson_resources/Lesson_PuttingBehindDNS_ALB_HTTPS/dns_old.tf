#DNS Configuration

variable "dns-name" {
  type    = string
  default = "<publicly-hosted-zone-ending-with-dot>" #example cmcloudlab1234.info.
}

#Get already , publicly configured Hosted Zone on Route53 - MUST EXIST
data "aws_route53_zone" "dns" {
  provider = aws.region-master
  name     = var.dns-name
}


#dns.tf
#Create Alias record towards ALB from Route53
resource "aws_route53_record" "jenkins" {
  provider = aws.region-master
  zone_id  = data.aws_route53_zone.dns.zone_id
  name     = join(".", ["jenkins", data.aws_route53_zone.dns.name])
  type     = "A"
  alias {
    name                   = aws_lb.application-lb.dns_name
    zone_id                = aws_lb.application-lb.zone_id
    evaluate_target_health = true
  }
}

#Add to outputs.tf for better segregation

output "url" {
  value = aws_route53_record.jenkins.fqdn
}