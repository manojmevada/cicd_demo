# PRD — Node.js Docker App CI/CD using GitHub Actions + OCI Free Tier

## 1. Project Title

Node.js Test App with Docker + GitHub Actions CI/CD + OCI Free VM Deployment

---

## 2. Goal

Create a small Node.js app and deploy it automatically to an Oracle Cloud Free Tier VM using:

- Node.js app
- Docker container
- GitHub repository
- GitHub Actions CI/CD
- OCI Free VM (Ubuntu)
- SSH public/private key login
- Auto deploy on push

**Flow:**
```
GitHub push
    ↓
GitHub Action runs
    ↓
Build Docker image
    ↓
Connect to OCI VM via SSH key
    ↓
Pull repo
    ↓
Run docker container
```


---

## 3. Tech Stack

| Component | Tool |
|----------|---------|
| App | Node.js + Express |
| Container | Docker |
| CI/CD | GitHub Actions |
| Cloud | Oracle Cloud Free Tier |
| VM OS | Ubuntu 22.04 |
| Auth | SSH Public / Private Key |
| Repo | GitHub |

---

## 4. Architecture

```
Local Dev
    ↓ push
GitHub Repo
    ↓
GitHub Actions
    ↓ SSH (private key)
OCI VM (free tier)
    ↓
Docker run node app
    ↓
Public IP access
```


---

## 5. OCI Setup

### 5.1 Create VM

Oracle Cloud → Compute → Instance

Settings:
```
Shape: VM.Standard.E2.1.Micro
OS: Ubuntu 22.04
Public IP: Yes
SSH key: Upload public key
```

Public key example:
```
id_rsa.pub
```


Private key stays in local / GitHub secret.

---

## 6. Project Structure

```
node-ci-app/
├── app.js
├── package.json
├── Dockerfile
├── docker-compose.yml
└── .github/
    └── workflows/
        └── deploy.yml
```


---

## 7. Node App

### 7.1 app.js

```js
const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("Node CI/CD App Running 🚀");
});

app.listen(3000, () => {
  console.log("Server started");
});
```

### 7.2 package.json

```bash
npm init -y
npm install express
```

---

## 8. Dockerfile

```dockerfile
FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
```

---

## 9. Docker Compose (on VM)

### docker-compose.yml

```yaml
version: "3"

services:
  nodeapp:
    build: .
    ports:
      - "80:3000"
```

---

## 10. GitHub Repo

Push project to GitHub:

```bash
git init
git add .
git commit -m "init"
git remote add origin <repo>
git push
```

---

## 11. Add GitHub Secrets

GitHub → Settings → Secrets → Actions

Add:

```
OCI_HOST = VM_PUBLIC_IP
OCI_USER = ubuntu
OCI_SSH_KEY = private key content
```

Private key example:

```
-----BEGIN RSA PRIVATE KEY-----
xxxx
-----END RSA PRIVATE KEY-----
```

---

## 12. GitHub Action CI/CD

### .github/workflows/deploy.yml

```yaml
name: Deploy Node App to OCI

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup SSH
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.OCI_SSH_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa

      - name: Deploy to OCI
        run: |
          ssh -o StrictHostKeyChecking=no \
          ${{ secrets.OCI_USER }}@${{ secrets.OCI_HOST }} << EOF
          cd node-ci-app || git clone https://github.com/YOUR/repo.git
          cd node-ci-app
          git pull
          docker compose down
          docker compose up -d --build
          EOF
```

---

## 13. VM First Time Setup

SSH to VM:

```bash
ssh -i id_rsa ubuntu@IP
```

Install docker:

```bash
sudo apt update
sudo apt install docker.io -y
sudo apt install docker-compose -y
sudo usermod -aG docker ubuntu
```

Logout / login again.

---

## 14. Test

Push code:

```bash
git push
```

GitHub Action runs.

Then open:

```
http://VM_PUBLIC_IP
```

Expected output:

```
Node CI/CD App Running 🚀
```