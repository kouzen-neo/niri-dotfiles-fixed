#!/usr/bin/env bash

set -euo pipefail

PIDFILE="/tmp/wf-recorder.pid"
OUTDIR="$HOME/Videos/screenrecord"

if pgrep -x "wf-recorder" >/dev/null; then
    # Stop recording
    killall -s SIGINT wf-recorder
    while pgrep -x "wf-recorder" >/dev/null; do
        sleep 0.1
    done

    LAST_FILE="$(cat "$PIDFILE" 2>/dev/null || echo "")"
    rm -f "$PIDFILE"

    if [ -n "$LAST_FILE" ] && [ -f "$LAST_FILE" ]; then
        notify-send --app-name="Screen Recorder" --expire-time=2500 "Perekaman Selesai" "$(basename "$LAST_FILE") tersimpan"
    else
        notify-send --app-name="Screen Recorder" --expire-time=2500 "Perekaman Selesai" "Video tersimpan di Videos/screenrecord"
    fi
else
    # Start recording
    mkdir -p "$OUTDIR"
    FILE="$OUTDIR/recording_$(date '+%Y-%m-%d_%H-%M-%S').mp4"
    echo "$FILE" > "$PIDFILE"

    # Capture system audio via PipeWire/Pulse default sink monitor
    DEFAULT_SINK="$(pactl get-default-sink 2>/dev/null || echo "")"
    if [ -n "$DEFAULT_SINK" ]; then
        AUDIO_OPT="--audio=${DEFAULT_SINK}.monitor"
    else
        AUDIO_OPT="--audio"
    fi

    notify-send --app-name="Screen Recorder" --expire-time=1500 "Perekaman Dimulai" "Suara sistem aktif. Super+Shift+G untuk berhenti"

    # Run in background
    nohup wf-recorder $AUDIO_OPT -f "$FILE" >/dev/null 2>&1 &
fi
