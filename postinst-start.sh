#!/bin/bash

source "postinst-yad.sh"

function exit_on_error() {
  if [ $? -ne 0 ]; then
    yad_message_ok "Setup Error" "An error has caused setup to fail and automatic deployment to stop.\n\n$1\n\nYour device will be restarted and setup will try again." "dialog-error"
    exit 1
  fi
}

(
./postinst-setbg.sh
./postinst-preflightchecks.sh
echo "100";
) | yad_progress_pulsate "Post Install" "Preparing post-install deployment scripts..." "clock"

./postinst-resetnetworking.sh || exit_on_error "Failed to reset networking."
./postinst-deleteusers.sh || exit_on_error "Failed to reset users."