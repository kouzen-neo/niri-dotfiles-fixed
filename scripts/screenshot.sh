#!/usr/bin/env bash

set -euo pipefail

readonly OUTDIR="$HOME/Pictures/Screenshots"
readonly MODE="${1:-full}"

mkdir -p "$OUTDIR"
FILE="$OUTDIR/$(date '+%Y-%m-%d_%H-%M-%S').png"

case "$MODE" in
  region)
    GEOM="$(slurp)" || exit 0
    grim -g "$GEOM" "$FILE"
    ;;
  full)
    grim "$FILE"
    ;;
  *)
    echo "Usage: $0 {full|region}" >&2
    exit 1
    ;;
esac

wl-copy --type image/png < "$FILE"
notify-send --app-name="Screenshot" --expire-time=1500 "Screenshot disalin ke clipboard" "$(basename "$FILE")"
