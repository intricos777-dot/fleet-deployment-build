# =====================================================================
# FLEET DEPLOYMENT SYSTEM-CHANGE SCRIPTS  (v2)
# Generated from torch-workspace data on 2026-10-06.
# Requires sudo (this host has no saved sudo password, so run these
# yourself):  sudo bash <this-script>
#
# Verified so far (2026-10-06):
#   - liaison-console   port 8788 : HTTP 200  (active)
#   - liaison-inbox     port 4124 : collector (active)
#   - shield-kitty-watch: journal tailer (active)
#   - component-resource-director: active
#   - coordination-server: active
#   - bhm-self-watchdog : active
#   - sen-isp           (restarted 2026-10-06 16:59:45, active)
#   - ollama            (active)
#   - USB device admission control  : installed  (99-shield-kitty-devices.rules)
#   - listener baseline : 12 ports on 4124/4126/5321/5322 (+ others)
#   - anchor set : 18/18 verified
#   - BCH wallet backup : done
#   - SSH key for GitHub : done
#   - miner scripts : done
# =====================================================================

set -euo pipefail
echo "=== FLEET DEPLOYMENT SYSTEM-CHANGE SCRIPTS (v2) ==="
echo "Host: $(hostname)  User: $(whoami)"
echo

# -------------------------------------------------
# Item 1: SSH PasswordAuthentication hardening
# -------------------------------------------------
echo "--- Item 1: SSH PasswordAuthentication hardening ---"
echo "Disables password auth; root/logic keys already configured (ssh-key done)."
echo "PasswordAuthentication no" | sudo tee /etc/ssh/sshd_config.d/99-password-auth.conf >/dev/null
echo "Wrote /etc/ssh/sshd_config.d/99-password-auth.conf"
echo "Restarting sshd..."
sudo systemctl restart sshd 2>/dev/null || sudo systemctl reload sshd 2>/dev/null || true
echo "Verify (should show 'PasswordAuthentication no'):"
grep -n PasswordAuthentication /etc/ssh/sshd_config.d/99-password-auth.conf /etc/ssh/sshd_config 2>/dev/null | grep -v '^\s*#' | head
echo

# -------------------------------------------------
# Item 2: IOWeight delegation  (cgroup)
# -------------------------------------------------
echo "--- Item 2: IOWeight delegation (cgroup) ---"
sudo mkdir -p /etc/systemd/system/user@1000.service.d
sudo tee /etc/systemd/system/user@1000.service.d/override.conf <<'EOF'
[Service]
Delegate=cpu cpuset io memory pids
EOF
sudo systemctl daemon-reload
echo "IOWeight delegation written to /etc/systemd/system/user@1000.service.d/override.conf"
echo

# -------------------------------------------------
# Item 3: Zen ISO build  (archiso)
# -------------------------------------------------
echo "--- Item 3: Zen ISO build (archiso) ---"
sudo pacman -S --noconfirm archiso
echo

# -------------------------------------------------
# Item 4: [community] repo in pacman.conf
# -------------------------------------------------
echo "--- Item 4: [community] repo in pacman.conf ---"
sudo tee -a /etc/pacman.conf <<'EOF'

[community]
Include = /etc/pacman.d/mirrorlist
EOF
echo "Added [community] to /etc/pacman.conf"
echo

echo "=== System-change phase complete ==="
echo "Remaining fleet items needing YOUR input (not sudo):"
echo "  - Dogecoin address   (valid Bech32 address)"
echo "  - Ravencoin route    (Ravencoin node route / URL)"
echo "  - Polsia PayPal      (real PayPal credentials to enable payouts)"
