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

### Mounting Volumes
echo "==== [START] Mounting Volumes ===="
MOUNTPOINT="$${mountpoint:-/vini}"
LABEL="VINI"

# Candidatos comuns: NVMe (Nitro) e sd/xvd
CANDIDATES="/dev/nvme1n1 /dev/nvme2n1 /dev/xvdf /dev/xvdd /dev/sdf /dev/sdd"
DEVICE=""

# Espera até 120s por qualquer candidato aparecer
for i in $(seq 1 24); do
  for d in $CANDIDATES; do
    if [ -b "$d" ]; then DEVICE="$d"; break 2; fi
  done
  sleep 5
done

if [ -n "$DEVICE" ]; then
  echo "Disco de dados detectado: $DEVICE"

  # Garante partição 1
  if ! lsblk -no NAME "$DEVICE" | grep -qE "$(basename "$DEVICE")p?1"; then
    parted -s "$DEVICE" mklabel gpt
    parted -s "$DEVICE" mkpart primary ext4 0% 100%
    udevadm settle || true
    sleep 3
  fi

  # Nome correto da partição
  if echo "$DEVICE" | grep -q nvme; then
    PART="$${DEVICE}p1"
  else
    PART="$${DEVICE}1"
  fi

  # Formata se ainda não tiver FS
  if [ -z "$(lsblk -no FSTYPE "$PART")" ]; then
    mkfs.ext4 -F -L "$LABEL" "$PART"
  fi

  # fstab por LABEL (robusto) e montagem
  mkdir -p "$MOUNTPOINT"
  if ! grep -q "LABEL=$LABEL" /etc/fstab; then
    echo "LABEL=$LABEL $MOUNTPOINT ext4 defaults,nofail 0 0" >> /etc/fstab
  fi

  mount -a
  echo "Montado: $PART -> $MOUNTPOINT"
else
  echo "Nenhum disco de dados detectado; pulando montagem."
fi

# --- Limpeza para poupar disco ---
apt-get clean
rm -rf /var/lib/apt/lists/*
journalctl --vacuum-size=50M || true