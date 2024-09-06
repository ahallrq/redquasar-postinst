#!/bin/bash

source "postinst-yad.sh"

(
    echo "Y" | ujust install-system-flatpaks | sed -u 's/^/#/' &
    # Nasty hack to get Yad to update the progress bar in pulsate mode with a long running command.
    COMMAND_PID=$!; while kill -0 $COMMAND_PID 2>/dev/null; do sleep 0.2; done
) | yad_progress_pulsate_log "Post Install" "Installing Flatpak packages" "clock"