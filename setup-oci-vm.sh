#!/bin/bash
# OCI VM Setup Script - Install Docker and Docker Compose v2
# Run this script on your OCI Ubuntu VM

set -e  # Exit on error

echo "🚀 Starting OCI VM setup for CI/CD deployment..."
echo ""

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
echo "🔑 Adding Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo "📝 Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine and Docker Compose plugin
echo "💿 Installing Docker Engine and Docker Compose plugin..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

# Enable Docker service
echo "⚙️  Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo ""
echo "✅ Docker installation complete!"
echo ""
echo "📋 Verifying installation..."
sudo docker --version
sudo docker compose version
echo ""
echo "⚠️  IMPORTANT: You must LOGOUT and LOGIN again for group changes to take effect!"
echo ""
echo "After logout/login, verify with:"
echo "  docker --version"
echo "  docker compose version"
echo "  docker ps"
echo ""
echo "🎉 Setup complete! Ready for CI/CD deployment."
