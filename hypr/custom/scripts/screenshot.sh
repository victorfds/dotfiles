#!/usr/bin/env bash
# Robust screenshot helper for illogical-impulse.
# Modes: full (default) | area | output
set -euo pipefail

mode="${1:-full}"
outdir="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")/Screenshots"
mkdir -p "$outdir"
stamp="$(date +%Y%m%d_%H%M%S)"
file="$outdir/Screenshot_${stamp}.png"

case "$mode" in
  area|region)
    target="area"
    extra=(--freeze)
    ;;
  output|monitor)
    target="output"
    extra=()
    ;;
  full|screen|*)
    target="output"
    extra=()
    ;;
esac

if command -v grimblast >/dev/null 2>&1; then
  grimblast --notify "${extra[@]}" copysave "$target" "$file"
  exit $?
fi

# Fallback without grimblast
case "$target" in
  area)
    geom="$(slurp)" || exit 1
    grim -g "$geom" - | tee "$file" | wl-copy --type image/png
    ;;
  *)
    mon="$(hyprctl activeworkspace -j | jq -r '.monitor')"
    grim -o "$mon" - | tee "$file" | wl-copy --type image/png
    ;;
esac
notify-send -a Hyprland "Screenshot" "Saved to $file and copied to clipboard"
