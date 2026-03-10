# Custom VPC Lab

## What I Built
A fully functional custom VPC from scratch, including public and private subnets, Internet Gateway, NAT Gateway, and a Bastion Host for secure private access.

## Architecture
```
Internet
    |
Internet Gateway
    |
Public Subnet (10.0.1.0/24)
    |               |
EC2 (nginx)     Bastion Host
                    |
            Private Subnet (10.0.2.0/24)
                    |
              Private EC2
                    |
              NAT Gateway (outbound only)
                    |
                Internet
```

## What I Did
- Created a custom VPC with CIDR block 10.0.0.0/16
- Created a public subnet (10.0.1.0/24) and private subnet (10.0.2.0/24)
- Attached an Internet Gateway to the VPC
- Created a route table with 0.0.0.0/0 → IGW and associated it with the public subnet
- Launched an EC2 in the public subnet, installed nginx, confirmed browser access
- Created a NAT Gateway in the public subnet with an Elastic IP
- Created a private route table with 0.0.0.0/0 → NAT Gateway
- Launched a private EC2 (no public IP) and a Bastion Host in the public subnet
- SSH chained: Laptop → Bastion → Private EC2
- Confirmed outbound internet from private EC2 via NAT (sudo apt update)

## Break/Fix Exercise
**Break:** Deleted the 0.0.0.0/0 route from the public route table
**Result:** nginx became unreachable from the browser
**Fix:** Re-added the route pointing to the IGW
**Lesson:** The route table is what makes a subnet public — without a route to the IGW, traffic has no path out

## Key Concepts Learned
- A subnet is public or private based on its route table, not its name
- IGW = two-way traffic (inbound + outbound)
- NAT Gateway = one-way traffic (outbound only) — private instances can reach the internet but cannot be reached from it
- Bastion Host = single secure SSH entry point into a private network
- NAT swaps the private IP with its own public IP when sending traffic out

## Mistakes Made and Fixed
- EC2 launched without auto-assign public IP enabled → fixed by enabling it in subnet settings
- Confused IGW with NAT initially → clarified through the break/fix exercise
