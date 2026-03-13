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

**Resource replacement** — Some changes (like AMI ID or subnet) cannot be made on a running instance. Terraform destroys and recreates the resource automatically.

---

## Core Commands

```bash
terraform init      # Download provider plugins
terraform plan      # Preview changes (dry run)
terraform apply     # Create or update infrastructure
terraform destroy   # Tear down all managed resources
```

---

## File Structure

```
terraform-labs/
├── main.tf               # Core infrastructure config
├── variables.tf          # Variable declarations
├── terraform.tfvars      # Actual variable values
├── outputs.tf            # Output values to display after apply
├── .gitignore            # Excludes state files from Git
└── terraform.tfstate     # NEVER push this to GitHub
```

---

## Variables

Variables make your Terraform config reusable across environments. Instead of hardcoding values, you declare them once and provide values separately.

**Without variables (hardcoded — bad):**
```hcl
resource "aws_instance" "practice_ec2" {
  ami           = "ami-038f4d4c8824bfed9"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0acf43f8538b5a022"
}
```

**With variables (reusable — good):**
```hcl
resource "aws_instance" "practice_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
}
```

### variables.tf — Declare variables

```hcl
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

`default` is optional — variables with a default do not need to be specified in `terraform.tfvars`. Variables without a default are required.

### terraform.tfvars — Provide actual values

```hcl
ami_id        = "ami-038f4d4c8824bfed9"
subnet_id     = "subnet-0acf43f8538b5a022"
instance_type = "t2.micro"
```

---

## Outputs

Outputs display values after `terraform apply` — useful for capturing things like instance IDs and public IPs that AWS generates at creation time.

### outputs.tf

```hcl
output "instance_id" {
  value = aws_instance.practice_ec2.id
}

output "public_ip" {
  value = aws_instance.practice_ec2.public_ip
}
```

**Sample output after apply:**
```
Outputs:
instance_id = "i-0d743eb64fae942b2"
public_ip   = "13.57.255.83"
```

---

## Full main.tf

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
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  tags = {
    Name = "terraform-practice-ec2"
  }
}
```

---

## .gitignore

Always include this in every Terraform project:

```
terraform.tfstate
terraform.tfstate.backup
.terraform/
.terraform.lock.hcl
```

**Why exclude tfstate?** The state file contains sensitive data including cached AWS credentials and resource identifiers. Never push it to a public repository. In production, state is stored remotely in S3 with DynamoDB locking so teams share the same state.

---

## Key Learnings

- Variables eliminate hardcoded values — same config works across environments
- `variables.tf` declares what variables exist; `terraform.tfvars` provides the actual values
- Variables without a `default` are required — Terraform will prompt if missing
- Outputs capture values that only exist after creation (instance ID, public IP)
- Some changes force resource replacement — AMI ID and subnet ID cannot be changed in-place
- `associate_public_ip_address = true` must be set at launch time — changing it forces replacement
