terraform {
  backend "s3" {
    bucket  = "myterraforms3bucketcloud"
    key     = "prod/website_vpc.tfstate"
    region  = "eu-north-1"
    profile = "Terraform-admin"
  }
}
