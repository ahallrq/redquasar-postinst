#!/bin/bash

source "postinst-yad.sh"

# Do a (mostly) full reset of networking on the machine.
# It's possible that this might be useless anyway since I think doing a rebase resets most of /etc/ anyway.


(
# NetworkMangler
echo "#Resetting NetworkManager to defaults..."
nmcli connection delete $(nmcli -t -f UUID connection show)
nmcli connection add type ethernet con-name "Ethernet" ifname '*' ipv4.method auto ipv6.method auto
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
rm -rf /etc/firewalld/zones/
cp -r /usr/lib/firewalld/zones/ /etc/firewalld/
firewall-cmd --complete-reload
firewall-cmd --reset
) | yad_progress_pulsate "Post Install" "Preparing post-install deployment scripts..." "clock"