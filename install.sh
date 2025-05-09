#!/bin/bash

# Paths
SCRIPT_DEST="/usr/local/bin/autologin.sh"
SERVICE_FILE="/etc/systemd/system/autologin.service"

# Copy the autologin script
echo "[+] Installing autologin.sh to $SCRIPT_DEST"
sudo cp autologin.sh "$SCRIPT_DEST"
sudo chmod +x "$SCRIPT_DEST"

# Create the systemd service
echo "[+] Creating systemd service at $SERVICE_FILE"
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Auto Login to Network Portal
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_DEST
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
echo "[+] Reloading systemd daemon..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "[+] Enabling autologin.service to start at boot..."
sudo systemctl enable autologin.service

echo "[+] Starting autologin.service now..."
sudo systemctl start autologin.service

echo "[?] Installation complete. Auto-login will run after boot when network is online."
