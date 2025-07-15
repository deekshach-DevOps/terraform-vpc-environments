# Terraform VPC Project with Prod and Dev Environments

This Terraform project provisions a custom Virtual Private Cloud (VPC) in AWS using modular Terraform. It supports two environments: **production** and **development**, each maintaining its own remote state in an S3 bucket.

---

## 📁 Project Structure

```
TERRAFORM_MODULES/
├── modules/
│   └── vpc/
│       ├── main.tf          # VPC creation logic
│       ├── outputs.tf       # Outputs from the module
│       └── variables.tf     # Input variables for the module
└── envs/
    ├── prod/
    │   ├── backend.tf       # S3 backend config for prod
    │   ├── main.tf          # Calls the VPC module
    │   ├── terraform.tfvars # Variable values for prod
    │   └── variables.tf     # Input variable declarations
    └── dev/
        ├── backend.tf       # S3 backend config for dev
        ├── main.tf          # Calls the VPC module
        ├── terraform.tfvars # Variable values for dev
        └── variables.tf     # Input variable declarations
```

---

## 🌍 Environments

Each environment has:

- Its own backend configuration (`backend.tf`) for storing Terraform state in S3.
- Independent variable values in `terraform.tfvars`.
- Calls to a common `vpc` module located in `modules/vpc/`.

---

## 🧱 Module Details (modules/vpc/)

This reusable module provisions the following:

- VPC with a custom CIDR block.
- Two public subnets.
- Two private application subnets.
- Two private data subnets.

Input variables and outputs are defined in `variables.tf` and `outputs.tf`.

---

## 📦 Inputs (`terraform.tfvars` example)

```
region                       = "eu-north-1"
project_name                 = "website-vpc-prod"
vpc_cidr                     = "10.0.0.0/16"
public_subnet_az1_cidr       = "10.0.0.0/24"
public_subnet_az2_cidr       = "10.0.1.0/24"
private_app_subnet_az1_cidr  = "10.0.2.0/24"
private_app_subnet_az2_cidr  = "10.0.3.0/24"
private_data_subnet_az1_cidr = "10.0.4.0/24"
private_data_subnet_az2_cidr = "10.0.5.0/24"
```

---

## 🚀 Usage

### For Production

```bash
cd envs/prod
terraform init
terraform apply
```

### For Development

```bash
cd envs/dev
terraform init
terraform apply
```

---

## 🗂 Remote State Configuration

Both environments store state remotely in S3 using `backend.tf`. Example:

```
terraform {
  backend "s3" {
    bucket  = "myterraforms3bucketcloud"
    key     = "prod/website_vpc.tfstate"  # or dev/...
    region  = "eu-north-1"
    profile = "Terraform-admin"
  }
}
```

---

## ✅ Best Practices Followed

- Separate environments with isolated state.
- Reusable and versionable Terraform modules.
- Clear variable separation using `terraform.tfvars`.
- Remote backend with S3 for state locking and sharing.


**Profile**: Terraform-admin
