#!/bin/bash

# This file contains a bunch of helper functions for yad. Mostly just presetting the dialog sizes, params, and whatnt.

export YAD_WIDTH=600
export YAD_AUTOKILLCLOSE=(--auto-close --auto-kill)

function yad_progress() {
    yad --progress --title="$1" --text="$2" --image="$3" --percentage=0 ${YAD_AUTOKILLCLOSE} --center --width=$YAD_WIDTH
}

function yad_progress_pulsate() {
    yad --progress --title="$1" --text="$2" --image="$3" --pulsate ${YAD_AUTOKILLCLOSE} --center --width=$YAD_WIDTH
}

function yad_message_ok() {
    yad --image "$3" --title "$1" --button=Ok:0 --text "$2" --center --width="$YAD_WIDTH" 
}