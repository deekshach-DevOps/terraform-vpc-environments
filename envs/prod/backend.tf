
terraform {
  backend "s3" {
    bucket  = "azure-terraform-vpc"
    key     = "prod/vpc/terraform.tfstate"
    region  = "eu-south-1"
    encrypt = true
  }
}

