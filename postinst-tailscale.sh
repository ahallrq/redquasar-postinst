#!/bin/bash

source postinst-yad.sh

# Run Tailscale up in the background, capturing output to a temp file
TEMP_FILE=$(mktemp)

# For some reason we can't catch tailscale's output with a standard 2>&1 redir. idk why
script -fqc 'tailscale up --accept-routes --timeout 130s' "$TEMP_FILE" &

# Wait for the login URL to appear in the logs
TIMEOUT=120
AUTH_URL="https://login.tailscale.com/a"

yad_message_ok "Tailscale" "Preparing to connect to Tailscale." "clock" --timeout=20 --no-buttons --no-escape &
PID=$!

while kill -0 $PID 2>/dev/null && [ -z "$LOGIN_KEY" ]; do
    LOGIN_KEY=$(grep -oP '(?<=https://login.tailscale.com/a/)[a-zA-Z0-9]+' "$TEMP_FILE")

    # Sleep briefly to avoid busy looping
    sleep 1
done

killall -9 yad

if [ -z "$LOGIN_KEY" ]; then
        yad_message_ok "Error" "Failed to retrieve Tailscale login URL within timeout" "dialog-error" && exit 1
fi

FULL_AUTH_URL="$AUTH_URL/$LOGIN_KEY"

# Generate QR code for the URL
qrencode -o /tmp/qr_code.png "$FULL_URL"

# Clean up the temp file
rm "$TEMP_FILE"

yad --image="/tmp/qr_code.png" \
    --title="Tailscale Login" \
    --text="To authenticate and connect to the Tailscale network, scan the QR code or visit:\n$FULL_URL" \
    --timeout=$TIMEOUT \
    --timeout-indicator=bottom \
    --no-escape --no-buttons --center &

PID=$!

while kill -0 $PID 2>/dev/null; do
    tailscale status | grep "Logged out."
    if [ $? -ne 0 ]; then
        killall -9 yad
        yad_message_ok "Tailscale Login Successful" "Successfully logged into the Tailscale network" "dialog-info" &
        exit 0
    fi
    sleep 1
done

yad_message_ok "Tailscale Login Failed" "Failed to connect and log into the Tailscale network" "dialog-error" && exit 1


