variable "region" {
    description = "The region in which application should be launched"
}

variable "private_sg" {
    description = "private security group"
}

variable "key_name" {
    description = ""
}

variable "private_subnet_id" {
    description = "subnet id for your application"
}

variable "sentry_ami" {
    description = "AMI id of sentry integrated application"
}

variable "ssl_arn" {
    description = "ssl arn"
}
