terraform {
  backend "s3" {
    bucket = "jenkins-server-bkt"
    region = "us-east-1"
    key = "jenkins-server/terraform.tfstate"
  }
}
