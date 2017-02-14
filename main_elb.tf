resource "aws_elb" "web" {
  
  name = "vgordey-elb"
  # The same availability zone as our instance
##  availability_zones = ["${aws_instance.web.*.availability_zone}"]
  security_groups    = ["${aws_security_group.elb.id}"]
  subnets         = ["${aws_subnet.main.*.id}"]
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

  # The instance is registered automatically
 ##################### instances = ["${aws_instance.web.id}"]

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_lb_cookie_stickiness_policy" "default" {
  name                     = "lbpolicy"
  load_balancer            = "${aws_elb.web.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

resource "aws_instance" "web" {
  instance_type = "${var.instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  subnet_id = "${aws_subnet.main.0.id}"
  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
  #
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
#########################  security_groups = ["${aws_security_group.default.name}"]
  user_data = "${file("userdata_elb.sh")}"

  #Instance tags
  tags {
    Name = "Vgordey_elb"
  }
}
