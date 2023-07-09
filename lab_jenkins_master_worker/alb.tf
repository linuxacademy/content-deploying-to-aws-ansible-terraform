// load balancer that is available to the public internet and designed to handle traffic from external users or the internet
resource "aws_lb" "application-lb" {
  provider           = aws.region-master
  name               = "jenkins-lb"
  internal           = false // indicates that the load balancer should have internet access
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags = {
    Name = "Jenkins-LB"
  }
}
/* alb listens to incoming http traffic on port 80 and forwards traffic to the target group, which is configured with a health check and targets the "jenkins-master" EC2 instance on port 8080.
These resources enable traffic routing to and load balancing on the behalf of the jenkins application running on the "jenkins-master" EC2 instance in AWS. 
resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-master
  name        = "app-lb-tg"
  port        = 8080
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_useast.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/login"
    port     = 8080
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "jenkins-target-group"
  }
}

resource "aws_lb_listener" "jenkins-listener-http" {
  provider          = aws.region-master
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
}

// health checks determine the availability of backend instances by sending a request to the specified instance and expecting a response within a certain time frame. If the target fails the health check, the load balancer will stop sending requests to unhealthy instances, helping ensure that traffic is only directed towards healthy instances, improving application reliability and availability.
Target groups are logical groupings of backend EC2 Instances that are registered with a load balancer. The load balancer uses target groups to distribute incoming requests across registered instances or targets based on the algorithm (round robin or least connections). Target groups ensure that traffic is distributed evenly across healthy instances and provides automatic failover by removing unhealthy instances from its load balancing rotation */

resource "aws_lb_target_group_attachment" "jenkins-master-attach" {
  provider         = aws.region-master
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.jenkins-master.id
  port             = 8080
}
