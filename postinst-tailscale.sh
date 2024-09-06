#!/bin/bash

# Run Tailscale up in the background, capturing output to a temp file
TEMP_FILE=$(mktemp)
tailscale up --timeout 120s 2>&1 > "$TEMP_FILE" &

# Wait for the login URL to appear in the logs
TIMEOUT=30
START_TIME=$(date +%s)

while true; do
    LOGIN_URL=$(grep -oP '(?<=https://login.tailscale.com/a/)[a-zA-Z0-9]+' "$TEMP_FILE")
    FULL_URL="https://login.tailscale.com/a/$LOGIN_URL"

    if [ ! -z "$LOGIN_URL" ]; then
        break
    fi

    # Check if timeout is reached
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$(( CURRENT_TIME - START_TIME ))

    if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
        yad --title="Error" --text="Failed to retrieve Tailscale login URL within timeout" --button=OK
        pkill tailscale
        rm "$TEMP_FILE"
        exit 1
    fi

    # Sleep briefly to avoid busy looping
    sleep 1
done

# Generate QR code for the URL
qrencode -o /tmp/qr_code.png "$FULL_URL"

START_TIME=$(date +%s)

# Clean up the temp file
rm "$TEMP_FILE"

yad --image="/tmp/qr_code.png" \
    --title="Tailscale Login" \
    --text="To authenticate, visit:\n$FULL_URL" \
    --timeout=$TIMEOUT \
    --timeout-indicator=bottom \
    --no-escape --no-buttons &

(
    while kill -0 $PID 2>/dev/null; do
        tailscale status | grep "Logged out."
        if [ ! -z $? ]; do
            exit 0
        fi
    done
) || yad --image="dialog-error" --title="Tailscale Login Failed" --text="Failed to connect and log into the Tailscale network" --escape-ok --button=OK && exit 1


