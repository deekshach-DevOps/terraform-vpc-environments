terraform {
  backend "s3" {
    bucket  = "myterraforms3bucketcloud"
    key     = "dev/website_vpc.tfstate"
    region  = "eu-north-1"
    profile = "Terraform-admin"
  }
}
