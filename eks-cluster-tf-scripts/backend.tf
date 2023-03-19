terraform {
  backend "s3" {
    bucket = "jenkins-server-bkt"
    region = "us-east-1"
    key = "eks/terraform.tfstate"
  }
}
