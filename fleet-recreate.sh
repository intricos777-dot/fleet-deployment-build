#!/bin/bash
# Watermark: Living_Sin (intricos777-dot) + AI agents (Hermes, Lia, opencode) - collaborative work
# Fleet deployment recreation script
# Generated from torch-workspace data

set -euo pipefail

echo "=== FLEET DEPLOYMENT RECREATION ==="
echo "Phase 1: System configuration changes (requires sudo)"
echo "=============================================================="

# 1. IOWeight delegation
echo ""
echo "--- Phase 1a: IOWeight delegation ---"
sudo mkdir -p /etc/systemd/system/user@1000.service.d
sudo tee /etc/systemd/system/user@1000.service.d/override.conf <<'EOF'
[Service]
Delegate=cpu cpuset io memory pids
EOF
sudo systemctl daemon-reload
echo "IOWeight delegation configured."

# 2. Zen ISO build
echo ""
echo "--- Phase 1b: Zen ISO build ---"
sudo pacman -S --noconfirm archiso
echo "Zen ISO tools installed."

# 3. [community] repo
echo ""
echo "--- Phase 1c: [community] repo ---"
sudo tee -a /etc/pacman.conf <<'EOF'

[community]
Include = /etc/pacman.d/mirrorlist
EOF
echo "[community] repo added to pacman.conf."

# 4. USB device admission control
echo ""
echo "--- Phase 1d: USB device admission control ---"
sudo /home/livings/Projects/shield-kitty/device-blacklist/install.sh
echo "USB admission control installed."

echo ""
echo "=== Phase 1 COMPLETE ==="
echo "All system configuration changes applied."

echo ""
echo "=== Phase 2: Verify ==="
echo "--- IOWeight ---"
systemctl --user show-environment 2>/dev/null | grep -i delegate || echo "NO Delegate= set"
cat /etc/systemd/system/user@1000.service.d/override.conf 2>/dev/null || echo "no override.conf"
echo "--- [community] ---"
grep -c '\[community\]' /etc/pacman.conf 2>/dev/null || echo "no [community] in pacman.conf"
echo "--- USB admission ---"
ls /home/livings/Projects/shield-kitty/device-blacklist/ 2>/dev/null | head -5
