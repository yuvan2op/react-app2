#!/usr/bin/env bash
# One-time EC2 setup for react-app2 deploys.
# Supports Ubuntu and Amazon Linux 2023.
# Run on the EC2 instance as a user with sudo access.
set -euo pipefail

APP_DIR="${APP_DIR:-$HOME/react-app2}"
COMPOSE_VERSION="${COMPOSE_VERSION:-v2.29.7}"

install_compose_plugin() {
  if docker compose version >/dev/null 2>&1; then
    echo "Docker Compose plugin already installed."
    return
  fi

  echo "Installing Docker Compose plugin..."
  sudo mkdir -p /usr/local/lib/docker/cli-plugins
  ARCH="$(uname -m)"
  sudo curl -fsSL \
    "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-${ARCH}" \
    -o /usr/local/lib/docker/cli-plugins/docker-compose
  sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
  docker compose version
}

if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
else
  echo "Cannot detect OS." >&2
  exit 1
fi

echo "Detected OS: ${NAME:-unknown} ${VERSION_ID:-}"

case "${ID:-}" in
  amzn)
    echo "Installing Docker on Amazon Linux..."
    sudo dnf install -y docker
    sudo systemctl enable --now docker
    install_compose_plugin
    ;;
  ubuntu|debian)
    echo "Installing Docker on Ubuntu/Debian..."
    sudo apt-get update
    sudo apt-get install -y docker.io docker-compose-plugin docker-compose
    sudo systemctl enable --now docker || true
    ;;
  *)
    echo "Unsupported OS: ${ID}. Install Docker and Compose manually." >&2
    exit 1
    ;;
esac

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
echo "  3. GitHub secret EC2_USER should be: ${USER} (ec2-user on Amazon Linux)"
echo "  4. Add GitHub secrets: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, EC2_HOST, EC2_USER, EC2_SSH_KEY"
echo "  5. Push to main — CI will copy docker-compose.prod.yml and deploy."
