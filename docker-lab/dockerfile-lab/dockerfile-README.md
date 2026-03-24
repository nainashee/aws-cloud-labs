# Dockerfile Lab — Building a Custom Docker Image

## Overview

Built a custom Docker image from scratch using a Dockerfile — serving a personalized HTML page via nginx instead of the default nginx page.

---

## What is a Dockerfile?

A Dockerfile is a set of instructions that tells Docker how to build a custom image step by step. Think of it as a recipe — each line is an instruction that adds a layer to your image.

---

## Files

```
dockerfile-lab/
├── Dockerfile
└── index.html
```

### Dockerfile

```dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
```

**`FROM nginx`** — sets the base image. Every Dockerfile starts here. Instead of building from scratch, you extend an existing image.

**`COPY index.html /usr/share/nginx/html/index.html`** — copies your custom HTML file into the container, replacing the default nginx page. `/usr/share/nginx/html/` is where nginx serves files from.

### index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>Hussain Ashfaque</title>
</head>
<body>
    <h1>Hello World from Hussain Ashfaque</h1>
</body>
</html>
```

---

## Commands

### Build the image
```powershell
docker build -t my-webpage .
```
- `-t my-webpage` — tags (names) the image
- `.` — tells Docker to look for the Dockerfile in the current directory

### Run the container
```powershell
docker run -d -p 8080:80 my-webpage
```
- `-d` — detached mode (runs in background)
- `-p 8080:80` — maps port 8080 on your machine to port 80 inside the container

Access at: `http://localhost:8080`

### Stop all running containers
```powershell
docker stop $(docker ps -q)
```
`-q` returns only container IDs (quiet mode) — stops all running containers at once.

### Remove all containers
```powershell
docker rm $(docker ps -a -q)
```
Removes all containers including stopped ones.

---

## Build Output Explained

```
[1/2] FROM docker.io/library/nginx:latest   ← pulled base image
[2/2] COPY index.html /usr/share/nginx/html ← copied custom HTML
```

Each instruction in the Dockerfile = one build step = one layer in the image.

---

## Key Learnings

- Every Dockerfile starts with `FROM` — the base image everything is built on
- `COPY` moves files from your local machine into the image at build time
- `-t` tags your image with a name so you can reference it easily
- `.` in `docker build` means "look for Dockerfile in current directory"
- `docker ps -q` returns only IDs — useful for scripting bulk operations
- Custom images are built on top of existing ones — you rarely start from scratch
