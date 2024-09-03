#!/bin/bash

# This file contains a bunch of helper functions for yad. Mostly just presetting the dialog sizes, params, and whatnt.

export YAD_WIDTH=600
export YAD_AUTOKILLCLOSE="--auto-close --auto-kill"
export YAD_NOCLOSE="--no-escape --no-buttons"
export YAD_PARAMS="--on-top --center"
export YAD_PROGLOG="--enable-log --log-expanded --log-height=400"

function yad_progress() {
    yad --progress --title="$1" --text="$2" --image="$3" --percentage=0 $YAD_AUTOKILLCLOSE $YAD_PARAMS $YAD_NOCLOSE --width=$YAD_WIDTH
}

function yad_progress_log() {
    yad --progress --title="$1" --text="$2" --image="$3" --percentage=0 $YAD_AUTOKILLCLOSE $YAD_PARAMS $YAD_NOCLOSE $YAD_PROGLOG --width=$YAD_WIDTH
}

function yad_progress_pulsate() {
    yad --progress --title="$1" --text="$2" --image="$3" --pulsate $YAD_AUTOKILLCLOSE $YAD_PARAMS $YAD_NOCLOSE --width=$YAD_WIDTH
}

function yad_progress_pulsate_log() {
    yad --progress --title="$1" --text="$2" --image="$3" --pulsate $YAD_AUTOKILLCLOSE $YAD_PARAMS $YAD_NOCLOSE $YAD_PROGLOG --width=$YAD_WIDTH
}

function yad_message_ok() {
    yad --image "$3" --title "$1" --button=Ok:0 --text "$2" $YAD_PARAMS --width="$YAD_WIDTH" 
}