#!/usr/bin/env bash

set -euo pipefail

readonly CACHE="$HOME/.cache/awww/last-wallpaper"

[[ -f "$CACHE" ]] || exit 0

WALL="$(cat "$CACHE")"
[[ -f "$WALL" ]] || exit 0

for _ in $(seq 1 30); do
  awww query > /dev/null 2>&1 && break
  sleep 0.1
done

awww img "$WALL" -t none
