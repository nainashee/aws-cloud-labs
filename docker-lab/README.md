# Docker Lab — Containers Basics

## What is Docker?

Docker solves the "it works on my machine" problem. It packages an application along with everything it needs to run — OS libraries, dependencies, runtime — into a **container** that runs identically on any machine.

**Image vs Container:**
- **Image** = the recipe (static blueprint)
- **Container** = the meal (a running instance created from the image)

You can create many containers from the same image.

---

## Installation

1. Download Docker Desktop from https://docs.docker.com/desktop/install/windows-install/
2. Install and launch Docker Desktop
3. Verify installation:

```powershell
docker --version
```

---

## Core Commands Used

### Pull an image from Docker Hub
```powershell
docker pull nginx
```
Downloads the nginx image from Docker Hub (public image registry) to your local machine.

### Run a container
```powershell
docker run -d -p 8080:80 nginx
```
- `-d` — run in detached mode (background)
- `-p 8080:80` — map port 8080 on your machine to port 80 inside the container
- nginx listens on port 80 by default (standard HTTP port)

Access it at: `http://localhost:8080`

### List running containers
```powershell
docker ps
```

### List all containers (including stopped)
```powershell
docker ps -a
```
Stopped containers stay on disk until explicitly removed.

### Stop a container
```powershell
docker stop <container-id>
```

### Remove a container
```powershell
docker rm <container-id>
```

---

## Port Mapping Explained

```
Your Machine (port 8080) → Container (port 80)
```

Port 80 is the default HTTP port inside the container. You map it to 8080 on your machine to avoid conflicts with other services already using port 80.

Two containers cannot share the same host port — just like two apartments can't have the same number.

---

## Container Lifecycle

```
docker pull    → download image
docker run     → create and start container
docker stop    → stop container (still exists on disk)
docker rm      → permanently delete container
docker ps -a   → view all containers including stopped ones
```

---

## Key Learnings

- Docker images are pulled from Docker Hub — a public registry of pre-built images
- A stopped container is not deleted — it stays on disk until you run `docker rm`
- Port mapping (`-p host:container`) is required to access container services from your browser
- `docker ps` shows only running containers — `docker ps -a` shows everything
- Tomorrow: write a custom **Dockerfile** to build your own image from scratch
