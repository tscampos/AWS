terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.6.2"
    }
  }

  backend "s3" {
    bucket = "terraform-state-bucket-tercio"
    key    = "state/terraform_state.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}