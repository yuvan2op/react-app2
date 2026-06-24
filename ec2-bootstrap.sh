#!/usr/bin/env bash
# One-time EC2 setup for react-app2 deploys.
# Run on the EC2 instance as a user with sudo access.
set -euo pipefail
APP_DIR="${APP_DIR:-/home/ubuntu/react-app2}"
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-plugin
sudo usermod -aG docker "$USER"
echo "Creating app directory at ${APP_DIR}..."
mkdir -p "${APP_DIR}"
if [[ ! -f "${APP_DIR}/.env" ]]; then
  cat > "${APP_DIR}/.env" <<'EOF'
DOCKERHUB_USERNAME=your-dockerhub-username
IMAGE_TAG=latest
MONGODB_URI=mongodb://mongo:27017/react_app2_practice
EOF
  echo "Created ${APP_DIR}/.env — edit DOCKERHUB_USERNAME before first deploy."
else
  echo "${APP_DIR}/.env already exists, skipping."
fi
echo ""
echo "Bootstrap complete. Next steps:"
echo "  1. Log out and back in so docker group membership applies."
echo "  2. Edit ${APP_DIR}/.env with your Docker Hub username."
echo "  3. Add GitHub secrets: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, EC2_HOST, EC2_USER, EC2_SSH_KEY"
echo "  4. Push to main CI will copy docker-compose.prod.yml and deploy."

