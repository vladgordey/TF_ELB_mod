resource "aws_elb" "web" {
  
  name = "${var.short_name}-elb"
  # The same availability zone as our instance
##  availability_zones = ["${aws_instance.web.*.availability_zone}"]
  security_groups    = ["${var.sec_group}"]
  subnets         = ["${var.subnets"]
##  subnets         = "${element(aws_subnet.main.*.id, count.index)}"  
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}



