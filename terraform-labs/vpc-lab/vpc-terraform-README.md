# Terraform VPC Lab — Full Network Infrastructure as Code

## Overview

Built a complete AWS VPC with public subnet and internet access using Terraform — no console required. All five components provisioned from a single `terraform apply`.

---

## Architecture

```
VPC (10.0.0.0/16)
└── Internet Gateway
└── Public Subnet (10.0.1.0/24) — us-west-1c
    └── Route Table (0.0.0.0/0 → IGW)
        └── Route Table Association
```

---

## Why Terraform for VPC?

Building a VPC manually in the console requires clicking through 5+ separate screens. With Terraform:
- The entire network is defined in one file
- It can be recreated identically in any account or region
- Changes are tracked and version controlled
- Terraform resolves dependency order automatically

---

## Resources Created

| Terraform Resource | AWS Component | Purpose |
|---|---|---|
| `aws_vpc` | VPC | Network container |
| `aws_internet_gateway` | IGW | Enable internet access |
| `aws_subnet` | Subnet | IP address range in one AZ |
| `aws_route_table` | Route Table | Direct traffic to IGW |
| `aws_route_table_association` | RT Association | Link subnet to route table |

---

## main.tf

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

resource "aws_vpc" "practice_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_internet_gateway" "vpc_IGW" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "aws_IGW"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.practice_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "practice_subnet"
  }
}

resource "aws_route_table" "practice_routetable" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_IGW.id
  }

  tags = {
    Name = "practice_routetable"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.practice_routetable.id
}
```

---

## How Resource References Work

Terraform resources reference each other using the pattern:
```
resource_type.resource_name.attribute
```

For example:
```hcl
vpc_id = aws_vpc.practice_vpc.id
```

This creates an implicit dependency — Terraform knows to create the VPC before the IGW, subnet, and route table. No need to define the order manually.

---

## Dependency Order

Terraform resolved the creation order automatically:

```
1. aws_vpc               (no dependencies)
2. aws_internet_gateway  (depends on VPC)
   aws_subnet            (depends on VPC) ← created in parallel
3. aws_route_table       (depends on VPC + IGW)
4. aws_route_table_association (depends on subnet + route table)
```

---

## Steps

```bash
# Initialize providers
terraform init

# Preview what will be created
terraform plan

# Build the infrastructure
terraform apply

# Tear it all down
terraform destroy
```

---

## Key Learnings

- A public subnet requires 5 connected resources — VPC, IGW, subnet, route table, association
- Terraform resolves dependency order automatically from resource references
- `0.0.0.0/0` in the route table means "all traffic" — directing it to the IGW makes the subnet public
- Without the route table association, the subnet has no route to the internet even if the route table exists
- Everything can be rebuilt identically from the code — no manual steps required
