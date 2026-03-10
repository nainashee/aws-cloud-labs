# Private Subnet, NAT Gateway & Bastion Host Lab

## What I Built
A secure two-tier network inside a custom VPC with a public subnet (Bastion Host) and a private subnet (private EC2), connected via NAT Gateway for outbound internet access.

## Architecture
```
Internet
    |
Internet Gateway
    |
Public Subnet (10.0.1.0/24)
    |               |
Bastion Host    NAT Gateway (Elastic IP)
(public IP)         |
    |         Private Subnet (10.0.2.0/24)
    |               |
    +----SSH------> Private EC2 (no public IP)
                    |
              outbound internet (apt update)
```

## What I Did
- Created private subnet: 10.0.2.0/24 inside practice-vpc
- Allocated an Elastic IP and created a NAT Gateway in the public subnet
- Created a private route table: 0.0.0.0/0 → NAT Gateway, associated with private subnet
- Launched a Bastion Host EC2 in the public subnet (with public IP)
- Launched a private EC2 in the private subnet (no public IP)
- Configured private EC2 security group: SSH allowed only from Bastion's private IP
- Copied .pem key to Bastion using `scp` (agent forwarding failed on Windows)
- SSH chained: Laptop → Bastion (10.0.1.154) → Private EC2 (10.0.2.59)
- Confirmed NAT Gateway works: ran `sudo apt update` successfully from private EC2
- Cleaned up: terminated both EC2s, deleted NAT Gateway, released Elastic IP

## SSH Chain Commands
```bash
# Step 1: Copy key to Bastion
scp -i "linux-practice-1.pem" "linux-practice-1.pem" ubuntu@<bastion-public-ip>:~/.ssh/

# Step 2: SSH into Bastion
ssh -i "linux-practice-1.pem" ubuntu@<bastion-public-ip>

# Step 3: From Bastion, SSH into Private EC2
ssh -i "~/.ssh/linux-practice-1.pem" ubuntu@10.0.2.59
```

## Key Concepts Learned
- A private subnet has no route to an IGW — instances cannot be reached from the internet
- NAT Gateway = outbound only — private instances can reach the internet but cannot be reached from it
- NAT swaps the private IP with its own Elastic IP when sending traffic out (Network Address Translation)
- IGW = two-way traffic, NAT = one-way outbound traffic
- Bastion Host = a single hardened EC2 in the public subnet that acts as the only SSH entry point to the private network
- Security group on private EC2 should only allow SSH from the Bastion's private IP — not from 0.0.0.0/0
- Elastic IP = static public IP that stays the same even if the NAT Gateway is recreated

## Cost Warning
- NAT Gateways are **not free** — they charge per hour and per GB of data processed
- Always delete NAT Gateways and release Elastic IPs after lab work to avoid unexpected charges

## Mistakes Made and Fixed
- SSH agent forwarding failed on Windows — resolved by copying the .pem key directly to the Bastion using `scp`
- Initially forgot to set private EC2 security group to allow SSH only from Bastion — corrected to use Bastion's private IP as the source
