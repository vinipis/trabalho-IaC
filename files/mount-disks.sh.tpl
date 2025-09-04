#!/bin/bash
set -euxo pipefail

devices="${device_list}"
i=1
for dev in $devices; do
  realdev=$(readlink -f "$dev" || echo "$dev")

  # Formata se ainda não tiver filesystem
  if ! blkid "$realdev" >/dev/null 2>&1; then
    mkfs -t xfs "$realdev"
  fi

  mkdir -p "/mnt/data${i}"

  # Usa UUID no fstab (mais estável em instâncias Nitro/NVMe)
  uuid=$(blkid -s UUID -o value "$realdev")
  if ! grep -q "$uuid" /etc/fstab; then
    echo "UUID=${uuid} /mnt/data${i} xfs defaults,nofail 0 2" >> /etc/fstab
  fi

  i=$((i+1))
done

systemctl daemon-reload || true
mount -a
