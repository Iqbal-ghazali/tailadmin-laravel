#!/bin/bash

# Script to fix Docker DNS issues on self-hosted runner

echo "=== Fixing Docker DNS Configuration ==="

# 1. Check current DNS settings
echo "Current DNS configuration:"
cat /etc/resolv.conf

# 2. Create Docker daemon configuration with Google DNS
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "dns": ["8.8.8.8", "8.8.4.4"],
  "dns-opts": ["timeout:3", "attempts:3"],
  "registry-mirrors": ["https://mirror.gcr.io"]
}
EOF

# 3. Restart Docker service
echo "Restarting Docker service..."
sudo systemctl restart docker
sleep 5

# 4. Test DNS resolution
echo "Testing DNS resolution..."
docker run --rm alpine nslookup registry-1.docker.io

# 5. Pull test image
echo "Testing Docker pull..."
docker pull hello-world

echo "=== DNS fix completed ==="
