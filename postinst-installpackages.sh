#!/bin/bash

source "postinst-yad.sh"

(
echo "Package installation"
ujust install-system-packages
) | yad_progress_pulsate_log "Post Install" "Installing Flatpak packages" "clock"