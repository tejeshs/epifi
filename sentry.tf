resource "aws_launch_configuration" "sentry_lc" {
    image_id = "${var.sentry_ami}"
    instance_type = "c5.xlarge"
    security_groups = ["${var.private_sg}"]
    key_name = "${var.key_name}"
    tags = [
        {
            key                 = "Name"
            value               = "sentry"
            propagate_at_launch = true
        },
        {
            key                 = "region"
            value               = "${var.region}"
            propagate_at_launch = true
        }
    ]
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "sentry_asg" {
    name = "sentry_asg-${aws_launch_configuration.sentry_lc.name}"
    min_size = 1
    max_size = 2
    desired_capacity = 1
    wait_for_elb_capacity = 1
    launch_configuration = "${aws_launch_configuration.sentry_lc.id}"
    vpc_zone_identifier = ["${var.private_subnet_id}"]
    load_balancers = ["${aws_elb.sentry-alb.name}"]
    health_check_type = "ELB"
    tags = [
        {
            key                 = "Name"
            value               = "sentry"
            propagate_at_launch = true
        },
        {
            key                 = "region"
            value               = "${var.region}"
            propagate_at_launch = true
        }
    ]
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_elb" "sentry-alb" {
    name = "sentry-alb"
    security_groups = ["${var.private_sg}"]
    subnets = ["${var.private_subnet_id}"]
    cross_zone_load_balancing = true
    connection_draining = true
    listener {
        lb_port = 443
        lb_protocol = "https"
        instance_port = 80
        instance_protocol = "http"
        ssl_certificate_id = "${var.ssl_arn}"
    }
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
    health_check {
        healthy_threshold = 4
        unhealthy_threshold = 2
        timeout = 2
        interval = 5
        target = "TCP:80"
    }
    tags {
        Name = "sentry"
    }
}
