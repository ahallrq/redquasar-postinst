#!/bin/bash

source "postinst-yad.sh"

(
    echo 50
    echo "Y" | ujust install-system-flatpaks | sed -u 's/^/#/'
) | yad_progress_pulsate_log "Post Install" "Installing Flatpak packages" "clock"