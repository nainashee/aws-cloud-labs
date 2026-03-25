# ECS Lab — Running Docker Containers on AWS

## Overview

Deployed a custom Docker container to AWS using ECS (Elastic Container Service) with Fargate — making the webpage accessible publicly via a browser without running anything locally.

---

## Architecture Diagram

![ECS Architecture](./ecs-architecture.svg)

---

## Architecture Flow

```
Local Machine
└── Dockerfile + index.html
        │
        │ docker build
        ▼
Local Docker Image (my-webpage)
        │
        │ docker tag + docker push
        ▼
ECR (Elastic Container Registry)
        │
        │ ECS pulls image
        ▼
ECS Fargate Task
        │
        │ Public IP
        ▼
Browser → http://<public-ip>
```

---

## Key Concepts

### ECR vs ECS

| | ECR | ECS |
|---|---|---|
| What it is | Image registry | Container runtime |
| Analogy | GitHub for Docker images | AWS-managed docker run |
| Purpose | Store and version images | Pull and run containers |

### ECS Components

**Cluster** — logical grouping of containers. The boundary that contains all your ECS resources.

**Task Definition** — the blueprint. Defines:
- Which image to run (ECR URI)
- CPU and memory allocation
- OS and launch type (Fargate)

**Service** — the manager. Ensures the desired number of tasks are always running. If a container crashes, the Service restarts it automatically.

**Fargate** — serverless container infrastructure. No EC2 instances to manage — AWS handles the underlying servers.

---

## Steps

### 1. Authenticate Docker to ECR
```powershell
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 513410254247.dkr.ecr.us-west-1.amazonaws.com
```

### 2. Build the image
```powershell
docker build -t my-webpage .
```

### 3. Tag the image with ECR URI
```powershell
docker tag my-webpage:latest 513410254247.dkr.ecr.us-west-1.amazonaws.com/my-webpage:latest
```
Adds the full ECR address as a label so Docker knows where to push it.

### 4. Push to ECR
```powershell
docker push 513410254247.dkr.ecr.us-west-1.amazonaws.com/my-webpage:latest
```

### 5. Create ECS Cluster
- Name: `my-webpage-cluster`
- Infrastructure: AWS Fargate

### 6. Create Task Definition
- Family name: `my-webpage`
- Launch type: Fargate
- OS: Linux
- CPU: 0.25 vCPU
- Memory: 0.5 GB
- Container image: ECR URI

### 7. Create Service
- Cluster: `my-webpage-cluster`
- Task definition: `my-webpage`
- Service name: `my-webpage-service`
- Desired tasks: 1

### 8. Allow inbound traffic
- Security group → add inbound rule: HTTP port 80 from 0.0.0.0/0
- Without this, the container runs but is unreachable from the browser

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `Unable to assume service linked role` | ECS role doesn't exist in account | `aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com` |
| Site can't be reached | Security group blocking port 80 | Add inbound HTTP rule to the task's security group |

---

## Cleanup

1. ECS → Services → delete `my-webpage-service`
2. ECS → Clusters → delete cluster
3. ECR → delete `my-webpage` repository

---

## Key Learnings

- ECR is to Docker images what GitHub is to code — a remote registry
- `docker tag` adds the destination address before pushing — like a shipping label
- Task Definition = what to run; Service = keep it running
- Fargate removes the need to manage EC2 instances for containers
- Security groups apply to ECS tasks just like EC2 — always check inbound rules if unreachable
