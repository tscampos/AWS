terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Provedor oficial da AWS mantido pela hashicorp
      version = "5.1.0"
    }
  }

  # Cria diretório para armazenamento do estado atual do projeto Terraform
  backend "s3" {
    bucket = "terraform-state-bucket-tercio"
    key    = "state/terraform_state.tfstate"
    region = "us-east-1"
  }
}

# Informa as configurações do provedor (AWS)
provider "aws" {
  region     = var.aws_region # us-east-1
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}