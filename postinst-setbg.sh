#!/bin/bash

source "postinst-yad.sh"

BACKGROUND_IMG="postinst-bg.png"

# 1. Set the root background image using xsetroot or feh
echo "Setting root background..."
if command -v feh &> /dev/null; then
    feh --bg-scale "$BACKGROUND_IMG"
elif command -v xsetroot &> /dev/null; then
    xsetroot -bitmap "$BACKGROUND_IMG"
else
    echo "Unable to set background - feh or xsetroot not found."
    echo "Not really a big deal. Exiting..."
    exit 1
fi