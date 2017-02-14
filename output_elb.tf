aws_elb" "web

output "elb_id" {
    value = "${aws_elb.web.id}"
}
