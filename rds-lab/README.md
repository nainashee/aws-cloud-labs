# RDS Lab — AWS Managed MySQL Database

## What is RDS and Why Use It?

Amazon RDS (Relational Database Service) is a managed database service that handles the heavy lifting of running a relational database — patching, backups, failover, and hardware provisioning. AWS manages the underlying server; you just interact with the database engine.

**RDS vs Self-Managed MySQL on EC2:**

| | RDS | MySQL on EC2 |
|---|---|---|
| Patching | AWS handles | You handle |
| Backups | Automated | Manual setup |
| Failover | Built-in (Multi-AZ) | DIY |
| Cost | Higher | Lower |
| Control | Limited | Full |

For most production workloads, RDS is preferred because it reduces operational overhead. Self-managed MySQL on EC2 makes sense only when you need deep OS-level control.

---

## Architecture

```
Your Laptop
     │
     │ SSH (port 22)
     ▼
EC2 Bastion Host (public subnet - 10.0.1.0/24)
     │
     │ MySQL (port 3306)
     ▼
RDS MySQL (private subnet - 10.0.2.0/24)
```

RDS sits in a private subnet with no public internet access. The EC2 instance acts as a jump box (bastion host) — the only way in is through it.

---

## Prerequisites

- VPC with at least one public subnet and two private subnets in different AZs
- Key pair (`.pem` file) for EC2 SSH access
- AWS CLI configured (`iamadmin-prod`)

---

## Steps

### 1. Create a Second Private Subnet
RDS requires subnets in at least 2 Availability Zones.

- Go to **VPC → Subnets → Create subnet**
- VPC: `practice-vpc`
- Name: `private-subnet-2-practice-vpc`
- AZ: `us-west-1a`
- CIDR: `10.0.3.0/24`

### 2. Create a DB Subnet Group
Tells RDS which subnets it's allowed to deploy into.

- Go to **RDS → Subnet Groups → Create DB Subnet Group**
- Name: `rds-subnet-group`
- VPC: `practice-vpc`
- Add both private subnets (`10.0.2.0/24` and `10.0.3.0/24`)

### 3. Launch RDS MySQL Instance

- Engine: MySQL Community
- Template: Dev/Test
- Instance class: `db.t3.micro` (burstable)
- DB identifier: `database-1`
- VPC: `practice-vpc`
- Subnet group: `rds-subnet-group`
- **Public access: No**
- Security group: `rds-sg` (new)

### 4. Launch EC2 Bastion Host

- AMI: Amazon Linux 2023
- Instance type: `t2.micro`
- VPC: `practice-vpc`
- Subnet: `Public-Subnet-practice-vpc`
- Auto-assign public IP: Enabled
- Security group: `bastion-sg` (allow SSH port 22 from your IP)

### 5. Configure Security Groups

**`rds-sg` inbound rule:**
- Type: MySQL/Aurora
- Port: 3306
- Source: `bastion-sg`

This ensures only the EC2 bastion can reach RDS — nothing else.

### 6. SSH into EC2 and Install MySQL Client

```bash
ssh -i linux-practice-1.pem ec2-user@<ec2-public-ip>
sudo dnf install mariadb105 -y
```

### 7. Connect to RDS

```bash
mysql -h <rds-endpoint> -u admin -p
```

Enter your master password when prompted.

### 8. Verify Connection

```sql
CREATE DATABASE testdb;
USE testdb;
CREATE TABLE employees (id INT, name VARCHAR(50));
INSERT INTO employees VALUES (1, 'Hussain');
SELECT * FROM employees;
```

Expected output:
```
+------+---------+
| id   | name    |
+------+---------+
|    1 | Hussain |
+------+---------+
```

---

## Key Concepts

**Why is public access disabled?**
Databases should never be directly reachable from the internet. Disabling public access means RDS has no public IP — the only path in is through the VPC.

**Why are 2 AZs required?**
RDS needs a second AZ available for Multi-AZ failover. Even if Multi-AZ is disabled, AWS requires the subnet group to span 2 AZs as a prerequisite.

**Security group chaining:**
Instead of allowing a specific IP into `rds-sg`, we reference `bastion-sg` as the source. This means any EC2 wearing `bastion-sg` can reach RDS — clean, scalable, and no hardcoded IPs.

---

## Cleanup

**Important — RDS charges by the hour. Delete when done.**

1. RDS → Databases → `database-1` → Actions → Delete
2. EC2 → Instances → `rds-bastion` → Terminate
3. Optionally delete `rds-subnet-group`, `rds-sg`, `bastion-sg`
