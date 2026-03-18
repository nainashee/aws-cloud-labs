# GitHub Actions CI/CD Lab — Automated Terraform Pipeline

## Overview

Built a CI/CD pipeline using GitHub Actions that automatically runs `terraform plan` every time code is pushed to the `main` branch. No manual runs needed — infrastructure changes are validated automatically.

---

## What is CI/CD?

**CI (Continuous Integration)** — automatically test and validate code every time it's pushed to the repository.

**CD (Continuous Delivery/Deployment)** — automatically deploy validated code to an environment.

In this lab, CI/CD is applied to **infrastructure code** (Terraform) rather than application code. Every push triggers an automated `terraform plan` to catch errors before they reach production.

---

## Architecture

```
Developer pushes code
        │
        ▼
GitHub detects push to main branch
        │
        ▼
GitHub Actions spins up Ubuntu runner
        │
        ├── Checkout code
        ├── Install Terraform
        ├── terraform init
        └── terraform plan ← validates infrastructure changes
```

---

## Workflow File

**Location:** `.github/workflows/terraform.yml`

```yaml
name: Terraform CI

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest

    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        run: terraform init
        working-directory: terraform-labs/vpc-lab

      - name: Terraform Plan
        run: terraform plan
        working-directory: terraform-labs/vpc-lab
```

---

## Key Concepts

**`on: push: branches: main`** — the trigger. Workflow runs only when code is pushed to the main branch.

**`runs-on: ubuntu-latest`** — GitHub spins up a fresh Ubuntu machine for every run. Nothing persists between runs.

**`uses` vs `run`**
- `uses` — runs a pre-built GitHub Action (someone else's reusable workflow step)
- `run` — executes a shell command directly on the runner

**`working-directory`** — tells each step which folder to run in. Must be a relative path from the repo root, not a local Windows path.

**`env` at job level** — environment variables available to all steps in the job. Used to pass AWS credentials without hardcoding them.

---

## AWS Credentials — GitHub Secrets

AWS credentials are stored as encrypted GitHub Secrets — never in code.

**Setup:**
1. Go to GitHub repo → Settings → Secrets and variables → Actions
2. Add `AWS_ACCESS_KEY_ID`
3. Add `AWS_SECRET_ACCESS_KEY`

The workflow accesses them via `${{ secrets.SECRET_NAME }}`. GitHub injects them at runtime — they never appear in logs or code.

**Why not hardcode credentials?**
Hardcoded keys in a public repo can be scraped by bots within minutes. GitHub Secrets are encrypted and only exposed to the workflow at runtime.

---

## Debugging Steps Encountered

| Error | Root Cause | Fix |
|---|---|---|
| `No configuration files` | `working-directory` pointed to wrong folder | Updated path to `terraform-labs/vpc-lab` |
| `No valid credential sources found` | Secret names didn't match workflow variables | Renamed secrets to `AWS_ACCESS_KEY_ID` |
| `invalid header field value for Authorization` | Secret value had special characters or spaces | Re-added secrets directly from downloaded CSV |

---

## Steps to Reproduce

```bash
# 1. Create workflow folder structure at repo root
mkdir -p .github/workflows

# 2. Create terraform.yml with workflow definition

# 3. Add AWS credentials as GitHub Secrets

# 4. Push to main branch
git add .
git commit -m "Add Terraform CI workflow"
git push origin main

# 5. Check Actions tab in GitHub for pipeline status
```

---

## Key Learnings

- GitHub Actions workflows must be in `.github/workflows/` at the **repo root** — not in a subfolder
- `working-directory` uses relative paths from repo root — never local Windows paths
- AWS credentials must be stored in GitHub Secrets, never in code
- `invalid header field value for Authorization` means the secret value is malformed — re-add from original source
- Every workflow run gets a fresh Ubuntu machine — nothing is cached between runs
- `terraform init` must run before `terraform plan` even in CI — it downloads the provider plugins
