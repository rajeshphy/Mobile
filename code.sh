#!/bin/bash

# Generates meta.js from assets/albums folder
# Assumes paths are relative to the site root (no BASEURL prefix)
# Requires: ImageMagick (identify) and FFmpeg (ffprobe)

OUTFILE="assets/js/meta.js"
mkdir -p "$(dirname "$OUTFILE")"

echo "Generating $OUTFILE with no baseurl..."

# Header
{
  echo "const folderList = ["
  find assets/albums -mindepth 1 -maxdepth 1 -type d | sort | while read dir; do
    folder=$(basename "$dir")
    echo "  \"$folder\","
  done
  echo "];"
  echo ""
  echo "const allFiles = ["
} > "$OUTFILE"

# Temp file to accumulate file entries
TMP_ENTRIES=$(mktemp)

# Image processing
find assets/albums -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | sort | while read file; do
  folder=$(basename "$(dirname "$file")")
  relpath="/$file"
  type="image"

  dimensions=$(identify -format "%w %h" "$file" 2>/dev/null)
  width=$(echo $dimensions | cut -d' ' -f1)
  height=$(echo $dimensions | cut -d' ' -f2)

  if [[ -z "$width" || -z "$height" ]]; then
    echo "Warning: Could not identify image $file"
    continue
  fi

  if (( width > height )); then
    orientation="landscape"
  else
    orientation="portrait"
  fi

  echo "  { folder: \"$folder\", src: \"$relpath\", type: \"$type\", orientation: \"$orientation\" }," >> "$TMP_ENTRIES"
done

# Video processing
find assets/albums -type f -iname '*.mp4' | sort | while read file; do
  folder=$(basename "$(dirname "$file")")
  relpath="/$file"
  type="video"

  dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$file" 2>/dev/null)
  width=$(echo $dimensions | cut -d',' -f1)
  height=$(echo $dimensions | cut -d',' -f2)

  if [[ -z "$width" || -z "$height" ]]; then
    echo "Warning: Could not get video dimensions for $file"
    continue
  fi

  if (( width > height )); then
    orientation="landscape"
  else
    orientation="portrait"
  fi

  echo "  { folder: \"$folder\", src: \"$relpath\", type: \"$type\", orientation: \"$orientation\" }," >> "$TMP_ENTRIES"
done

# Trim trailing comma and finalize
sed '$ s/,$//' "$TMP_ENTRIES" >> "$OUTFILE"
rm "$TMP_ENTRIES"

echo "];" >> "$OUTFILE"

echo "✅ Done. meta.js has been generated without baseurl prefix."
