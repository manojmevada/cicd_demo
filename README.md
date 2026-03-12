# Node.js CI/CD Demo with GitHub Actions + OCI

A simple Node.js Express application with automated CI/CD deployment to Oracle Cloud Infrastructure (OCI) Free Tier using GitHub Actions.

## 🚀 Features

- Express.js REST API
- Docker containerization
- Automated CI/CD with GitHub Actions
- Deployment to OCI Free Tier VM
- Health check endpoint
- Zero-downtime deployment

## 📋 Prerequisites

- OCI Free Tier account with a VM (Ubuntu 22.04)
- SSH key pair for VM access
- GitHub account and repository
- Docker installed on OCI VM

## 🛠️ Project Structure

```
cicd_demo/
├── app.js                    # Express application
├── package.json              # Node.js dependencies
├── Dockerfile                # Docker image configuration
├── docker-compose.yml        # Docker Compose setup
├── .gitignore                # Git ignore rules
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions workflow
└── README.md                 # This file
```

## 🔧 Local Development

1. Install dependencies:
```bash
npm install
```

2. Run the application:
```bash
npm start
```

3. Access the app:
- Main endpoint: http://localhost:3000
- Health check: http://localhost:3000/health

## 🐳 Docker Testing (Optional)

Build and run with Docker:
```bash
docker build -t cicd-demo .
docker run -p 3000:3000 cicd-demo
```

Or use Docker Compose:
```bash
docker compose up -d
```

## 📦 GitHub Secrets Setup

Add these secrets in your GitHub repository (Settings → Secrets → Actions):

| Secret Name | Description | Example |
|------------|-------------|---------|
| `OCI_HOST` | OCI VM public IP address | `123.456.789.012` |
| `OCI_USER` | SSH username for VM | `ubuntu` |
| `OCI_SSH_KEY` | Private SSH key content | `-----BEGIN RSA PRIVATE KEY-----\n...` |

### How to add secrets:
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with the exact name and value

## 🖥️ OCI VM Setup

SSH into your OCI VM and run:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install docker.io -y

# Install Docker Compose
sudo apt install docker-compose -y

# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again for group changes to take effect
exit
```

SSH back in and verify:
```bash
docker --version
docker compose version
```

## 🚀 Deployment

The application deploys automatically when you push to the `main` branch:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

### Manual deployment trigger:
1. Go to **Actions** tab in GitHub
2. Select **Deploy Node App to OCI** workflow
3. Click **Run workflow**

## 🔍 Monitoring

### Check GitHub Actions:
- Go to **Actions** tab in your GitHub repository
- View workflow runs and logs

### Check deployment on OCI:
```bash
# SSH into VM
ssh -i your-key.pem ubuntu@YOUR_VM_IP

# Check running containers
docker compose ps

# View logs
docker compose logs -f

# Check container health
docker ps
```

### Test the application:
```bash
# From anywhere
curl http://YOUR_VM_IP/

# Expected output:
# Node CI/CD App Running 🚀
```

## 📊 Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Main app endpoint |
| `/health` | GET | Health check (returns JSON) |

## 🔒 Security Notes

- Never commit SSH private keys to the repository
- Use GitHub Secrets for sensitive data
- Ensure OCI security lists allow inbound traffic on port 80
- Keep your VM and packages updated

## 🐛 Troubleshooting

### Deployment fails:
1. Check GitHub Actions logs
2. Verify all secrets are set correctly
3. Ensure OCI VM is running and accessible
4. Check SSH key format (should be OpenSSH format)

### Container won't start:
```bash
# SSH into VM
docker compose logs

# Rebuild container
docker compose down
docker compose up -d --build
```

### Port 80 blocked:
- Check OCI Security List rules (allow ingress 0.0.0.0/0 → port 80)
- Check Ubuntu firewall: `sudo ufw status`

## 📝 CI/CD Workflow

1. Developer pushes code to `main` branch
2. GitHub Actions workflow triggers
3. Workflow connects to OCI VM via SSH
4. Pulls latest code from GitHub
5. Rebuilds Docker container
6. Deploys updated container
7. Verifies deployment with health check

## 🎯 Next Steps

- [ ] Add HTTPS with Let's Encrypt
- [ ] Implement environment-specific configurations
- [ ] Add automated tests
- [ ] Set up monitoring and alerts
- [ ] Add database integration
- [ ] Implement logging aggregation

## 📄 License

ISC

## 👨‍💻 Author

Your Name

---

**Happy coding! 🚀**
