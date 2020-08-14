#ACM CONFIGURATION
resource "aws_acm_certificate" "aws-ssl-cert" {
  provider          = aws.region-master
  domain_name       = join(".", [var.site-name, data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = "Webservers-ACM"
  }

}

#Validates ACM issued certificate via Route53
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.region-master
  certificate_arn         = aws_acm_certificate.aws-ssl-cert.arn
  for_each                = aws_route53_record.cert_validation
  validation_record_fqdns = [aws_route53_record.cert_validation[each.key].fqdn]
}

####ACM CONFIG END


resource "aws_lb" "application-lb" {
  provider           = aws.region-master
  name               = "webservers-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.security_group_lb.id]
  subnets            = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]
  tags = {
    Name = "Webservers-LB"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-master
  name        = "app-lb-tg"
  port        = 80
  target_type = "instance"
  vpc_id      = data.aws_vpc.vpc_master.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/index.html"
    port     = 80
    protocol = "HTTP"
    matcher  = "200-399"
  }
  tags = {
    Name = "webserver-target-group"
  }
}

resource "aws_lb_listener" "lb-https-listener" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.aws-ssl-cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
}

resource "aws_lb_listener" "lb-http-listener" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "apache1-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = data.aws_instance.apache1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "apache2-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = data.aws_instance.apache2.id
  port             = 80
}
