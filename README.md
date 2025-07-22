# Terraform VPC Project with Prod and Dev Environments

This repository demonstrates how to provision a custom Virtual Private Cloud (VPC) in AWS using modular Terraform with separate **production** and **development** environments. It also serves as a base to explore different approaches using **Terraform** and **Terragrunt** in future iterations.

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
    │   ├── prod.tfvars      # Variable values for prod
    │   └── variables.tf     # Input variable declarations
    └── dev/
        ├── backend.tf       # S3 backend config for dev
        ├── main.tf          # Calls the VPC module
        ├── dev.tfvars       # Variable values for dev
        └── variables.tf     # Input variable declarations
```

---

## 🚀 CI/CD with Azure DevOps

Terraform provisioning is now automated using **Azure DevOps Pipelines**.

### ✅ Pipeline Overview

- Triggered on push to the `main` branch
- Performs:
  - `terraform init`
  - `terraform validate`
  - `terraform plan`
  - `terraform apply`
- Runs in a self-hosted or Microsoft-hosted agent (if parallelism is approved)
- Uses secure variable groups for AWS credentials

### 📄 Key Files

- `azure-pipelines.yml` — defines the entire pipeline
- `envs/dev/` — used by default for Terraform actions

### 📦 Azure DevOps Setup

1. Connect this GitHub repo to Azure DevOps
2. Go to **Pipelines > Library > Variable Group** and create `aws-credentials`:
   - `AWS_ACCESS_KEY_ID` (Secret ✅)
   - `AWS_SECRET_ACCESS_KEY` (Secret ✅)
   - `AWS_SESSION_TOKEN` (Optional, if using SSO)
   - `AWS_REGION` (e.g., `eu-south-1`)
3. Configure a self-hosted agent (or request hosted parallelism)
4. Run the pipeline from Azure DevOps UI or via Git pushes

### 📂 Switching Environments

To deploy `prod`, change the working directory in the pipeline:

```yaml
cd envs/prod
terraform apply -var-file=prod.tfvars
```

---

## 🌍 Environments

Each environment has:

- Its own backend configuration (`backend.tf`) for storing Terraform state in S3
- Independent variable values in `.tfvars`
- Calls to a shared `vpc` module

---

## 🧱 Module Details (`modules/vpc/`)

This reusable module provisions:

- A VPC with a custom CIDR block
- Two public subnets
- Two private application subnets
- Two private data subnets

Inputs and outputs are defined in `variables.tf` and `outputs.tf`

---

## 📦 Inputs (`dev.tfvars` example)

```hcl
region                       = "eu-south-1"
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

## 🗂 Remote State Configuration

Each environment stores state in S3 using `backend.tf`. Example for dev:

```hcl
terraform {
  backend "s3" {
    bucket  = "azure-terraform-vpc"
    key     = "dev/vpc/terraform.tfstate"
    region  = "eu-south-1"
    profile = "devops-admin"
  }
}
```

---

## 🔐 AWS SSO Authentication (CI/CD Setup)

### 🛠 Prerequisite

Ensure you have AWS CLI v2+ installed:
```bash
aws --version
```

### 🔧 Step 1: Configure SSO Profile Locally

```bash
aws configure sso --profile <your-profile-name>

```

You’ll be prompted for:
- SSO start URL 
- Region
- AWS account ID and role name

Creates this entry in `~/.aws/config`:
```ini
[profile <your-profile-name>]
sso_start_url = https://your-org.awsapps.com/start
sso_region    = eu-south-1
sso_account_id = 123456789012
sso_role_name  = TerraformAdministrator
region         = eu-south-1
```

### 🔐 Step 2: Log in

```bash
aws sso login --profile <your-profile-name>
```

### 📤 Step 3: Export Temporary Credentials
To extract credentials for use in Azure DevOps

```bash
aws configure export-credentials --profile <your-profile-name>
```
This will return:
-AWS_ACCESS_KEY_ID
-AWS_SECRET_ACCESS_KEY
-AWS_SESSION_TOKEN

Copy these and add them to your Azure DevOps variable group (aws-credentials) as secrets.


### 🔎 Step 4: Verify Identity

```bash
aws sts get-caller-identity --profile devops-admin
```

---

## ⚙️ Manual Usage Instructions (Optional)

Use these only if running Terraform manually (outside CI/CD).

### For Production

```bash
cd envs/prod
aws sso login --profile devops-admin
terraform init
terraform apply -var-file=prod.tfvars
```

### For Development

```bash
cd envs/dev
aws sso login --profile devops-admin
terraform init
terraform apply -var-file=dev.tfvars
```

---

## ✅ Best Practices Followed

- CI/CD with Azure DevOps for repeatable, auditable infrastructure changes
- Separate environments with isolated state
- Modular Terraform structure
- Secure AWS credential handling
- Remote state with S3

---

## 📌 Coming Soon

- 🔄 Terragrunt comparison setup
- 🔁 PR-triggered Terraform plans
