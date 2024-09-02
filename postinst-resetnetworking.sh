#!/bin/bash

source "postinst-yad.sh"

# Do a (mostly) full reset of networking on the machine.
# It's possible that this might be useless anyway since I think doing a rebase resets most of /etc/ anyway.


(
# NetworkMangler
echo "#Resetting NetworkManager to defaults..."
nmcli connection delete $(nmcli -t -f UUID connection show)
systemctl restart NetworkManager

# Tailscale
echo "#Resetting Tailscale to defaults..."
systemctl stop tailscaled
rm -rf /var/lib/tailscale/*
systemctl start tailscaled

# Wireguard
echo "#Resetting WireGuard to defaults..."
for conf in /etc/wireguard/*.conf; do
    # Extract the base name of the .conf file (without directory and extension)
    base_name=$(basename "$conf" .conf)

    # Attempt to disable and stop the corresponding wgquick@ service
    systemctl disable --now "wg-quick@$base_name"
done
rm -f /etc/wireguard/*

# Firewall
echo "#Resetting firewalld to defaults..."
rm /etc/firewalld/zones/*
cp /usr/lib/firewalld/zones/* /etc/firewalld/zones/
firewall-cmd --complete-reload
firewall-cmd --reset
) | yad_progress_pulsate "Post Install" "Preparing post-install deployment scripts..." "clock"