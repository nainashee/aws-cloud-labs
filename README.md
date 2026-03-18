# AWS Cloud Labs — Hussain Ashfaque

## About Me

IT Analyst transitioning into Cloud Support Engineering and Junior Cloud Engineering roles, with a long-term goal in data engineering. Currently building hands-on AWS experience through a structured 24-week lab program.

**AWS Certified:** Solutions Architect – Associate (SAA-C03) ✅

---

## What This Repository Is

A portfolio of hands-on AWS labs built from scratch — no guided tutorials, no click-through courses. Each lab solves a real-world problem, follows production best practices, and is documented with architecture diagrams, key decisions, and lessons learned.

---

## Labs Completed

| Lab | Key Skills | Status |
|-----|-----------|--------|
| [VPC Lab](./vpc-lab/) | Custom VPC, subnets, IGW, route tables | ✅ Complete |
| [Private Subnet + Bastion Host](./private-subnet-bastion-lab/) | NAT Gateway, SSH jump box, least privilege networking | ✅ Complete |
| [IAM Lab](./iam-lab/) | Users, policies, least privilege, MFA | ✅ Complete |
| [S3 Lab](./s3-lab/) | Buckets, policies, boto3 automation | ✅ Complete |
| [boto3 EC2 Automation](./boto3.ec2-lab/) | Python automation, waiters, instance lifecycle | ✅ Complete |
| [CloudWatch Lab](./cloudwatch-lab/) | Metrics, alarms, SNS notifications, alarm lifecycle | ✅ Complete |
| [RDS Lab](./rds-lab/) | Managed MySQL, private subnet, DB subnet groups, SG chaining | ✅ Complete |
| [Terraform Labs](./terraform-labs/) | IaC, variables, outputs, VPC provisioning, drift detection | ✅ Complete |
| [GitHub Actions CI/CD](./terraform-labs/) | CI/CD pipeline, automated terraform plan, GitHub Secrets, workflow triggers | ✅ Complete |
| [Docker Lab](./docker-lab/) | Images, containers, port mapping, container lifecycle | ✅ Complete |

---

## Technical Skills Demonstrated

- **Networking:** VPC design, subnet architecture, IGW, NAT Gateway, route tables, security groups
- **Compute:** EC2 lifecycle management, IAM roles, instance metadata (IMDSv2)
- **Storage:** S3 bucket policies, object storage, log management
- **Database:** RDS MySQL, DB subnet groups, private connectivity via bastion
- **Monitoring:** CloudWatch metrics, alarms, SNS alerting, alarm lifecycle states
- **Automation:** Python/boto3, EC2 automation scripts, waiters
- **Infrastructure as Code:** Terraform — variables, outputs, state management, drift detection
- **CI/CD:** GitHub Actions — automated Terraform validation on every push, secrets management
- **Containers:** Docker — images, containers, port mapping, container lifecycle
- **Security:** IAM least privilege, role-based authentication, no hardcoded credentials

---

## Capstone Project

### EC2 Health Monitor & Alerting System
An automated monitoring pipeline built entirely with Python/boto3 and AWS services:
- EC2 reads its own CPU metrics from CloudWatch via IMDSv2
- Writes JSON health logs to S3 every run
- CloudWatch alarm triggers SNS email alert when CPU exceeds 50%
- IAM role-based authentication — no hardcoded credentials

**Services:** EC2 · CloudWatch · S3 · SNS · IAM · Python/boto3

---

## Learning Plan

**24-week structured program (currently Week 11):**

- ✅ Phase 1 (Weeks 1–8): Linux, AWS Core Services, Capstone
- ✅ Phase 2 (Weeks 9–12): Terraform, IaC, GitHub Actions, CI/CD
- 🔄 Phase 3 (Weeks 13–16): Docker, ECS
- ⏳ Phase 3 continuing (Weeks 17–22): Flagship Capstone
- ⏳ Phase 4 (Weeks 23–24): Interview Preparation

---

## Connect

- 💼 [LinkedIn](https://www.linkedin.com/in/hussain-ashfaque)
- 📧 Available for Cloud Support / Junior Cloud Engineer roles
