#!/bin/bash
set -euxo pipefail
# loga a saída do user-data (facilita ver erro)
exec > >(tee -a /var/log/user-data.log) 2>&1

export DEBIAN_FRONTEND=noninteractive

# Pacotes básicos
apt-get update -y
apt-get install -y jq lvm2 python-is-python3 python3-simplejson python3-apt python3-pip s3cmd parted vnstat ca-certificates curl gnupg lsb-release chrony

# Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Instala Docker
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Usuário no grupo docker (Ubuntu AMI usa 'ubuntu')
usermod -aG docker ubuntu || true

# daemon.json se não existir
if [ ! -f /etc/docker/daemon.json ]; then
  cat > /etc/docker/daemon.json <<'EOF'
{
  "log-driver": "json-file",
  "log-opts": { "max-size": "1024m", "max-file": "5" }
}
EOF
  systemctl restart docker
fi

# Habilita serviços
systemctl enable --now docker
systemctl enable --now chrony
