# Terraform Lab — Infrastructure as Code on AWS

## What is Terraform and Why Use It?

Terraform is an Infrastructure as Code (IaC) tool that lets you define and provision AWS resources using configuration files instead of clicking through the console.

**Key advantage over boto3 scripts or the console:**
Terraform is *stateful* and *idempotent* — it tracks what it has created and only makes changes when your config differs from reality. Run it 10 times with no changes, nothing happens.

| | Console | boto3 Script | Terraform |
|---|---|---|---|
| Repeatable | No | Partial | Yes |
| Tracks state | No | No | Yes |
| Detects drift | No | No | Yes |
| Version controlled | No | Yes | Yes |

---

## Core Concepts

**State** — Terraform stores the current state of your infrastructure in `terraform.tfstate`. It uses this file to diff your config against reality.

**Idempotency** — Running `terraform apply` multiple times produces the same result. No duplicates, no errors.

**Drift detection** — If someone manually changes infrastructure in the console, Terraform detects the drift on the next `apply` and corrects it back to what the code says.

---

## Core Commands

```bash
terraform init      # Download provider plugins
terraform plan      # Preview changes (dry run)
terraform apply     # Create or update infrastructure
terraform destroy   # Tear down all managed resources
```

---

## Lab: Provision an EC2 Instance

### File Structure
```
terraform-labs/
├── main.tf
├── .gitignore
└── terraform.tfstate       ← never push this to GitHub
```

### main.tf

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "practice_ec2" {
  ami           = "ami-0d53d72369335a9d6"
  instance_type = "t2.micro"
  subnet_id     = "<your-public-subnet-id>"

  tags = {
    Name = "terraform-practice-ec2"
  }
}
```

### Steps

1. **Initialize** — downloads the AWS provider plugin
```bash
terraform init
```

2. **Plan** — preview what will be created
```bash
terraform plan
```

3. **Apply** — provision the infrastructure
```bash
terraform apply
```
Type `yes` to confirm.

4. **Verify drift detection** — manually change the Name tag in the AWS console, then run `terraform apply` again. Terraform detects the change and reverts it.

5. **Destroy** — tear down all resources
```bash
terraform destroy
```

---

## .gitignore

Always include this in your Terraform projects:

```
terraform.tfstate
terraform.tfstate.backup
.terraform/
.terraform.lock.hcl
```

**Why exclude tfstate?** The state file can contain sensitive data including cached AWS credentials and resource identifiers. Never push it to a public repository.

In production, state is stored remotely in S3 with DynamoDB locking so teams share the same state.

---

## Key Learnings

- `terraform init` must be run once per project to download providers
- `terraform plan` is always safe — it never changes anything
- State file is the source of truth — never delete or manually edit it
- Terraform corrects drift automatically on next `apply`
- `.terraform/` directory contains the provider binaries — no need to commit
