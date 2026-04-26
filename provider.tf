provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "aws-iac-1915-tf"
    key          = "terraform.tfstate-gha-cicd"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

