terraform {
  backend "s3" {
    bucket  = "dev-terraform-vpc"
    key     = "dev/vpc/terraform.tfstate"
    region  = "eu-south-1"
     encrypt = true
  }
}
