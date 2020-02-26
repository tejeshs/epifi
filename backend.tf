terraform {
  backend "s3" {
    bucket = "bucket-name"
    key    = ""
    region = "us-east-1"
  }
}

