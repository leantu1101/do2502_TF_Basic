
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
/*
  # Store tfstate file in S3
  backend "s3" {
    bucket = "devops2502-tfstate"
    key = "terraform.tfstate"
    region = "eu-west-3"
  } */
}


# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}