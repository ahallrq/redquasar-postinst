#!/bin/bash

source "postinst-yad.sh"

(
echo "Package installation"
ujust install-system-flatpaks
) | yad_progress_pulsate_log "Post Install" "Installing Flatpak packages" "clock"