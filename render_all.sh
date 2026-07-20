#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

OUTPUT_DIR="$SCRIPT_DIR/render_finish"
MODE="${1:-m}"

usage() {
  cat <<'EOF'
Usage:
  ./render_all.sh [m|a|l|i|mi|ai|li]

Run this script from inside the june/ folder, or call it as:
  ./june/render_all.sh

Modes:
  m   Render videos in medium quality (720p). Default.
  a   Render videos in high quality (1080p).
  l   Render videos in low quality (480p).
  i   Render PNG images instead of videos. Uses medium quality unless combined.

Examples:
  ./render_all.sh       # medium mp4
  ./render_all.sh m     # medium mp4
  ./render_all.sh a     # high mp4
  ./render_all.sh l     # low mp4
  ./render_all.sh i     # medium png
  ./render_all.sh ai    # high png
EOF
}

if [[ "$MODE" == "-h" || "$MODE" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "$MODE" =~ [^mali] ]]; then
  echo "Invalid mode: $MODE"
  usage
  exit 2
fi

quality_count=0
[[ "$MODE" == *m* ]] && quality_count=$((quality_count + 1))
[[ "$MODE" == *a* ]] && quality_count=$((quality_count + 1))
[[ "$MODE" == *l* ]] && quality_count=$((quality_count + 1))

if (( quality_count > 1 )); then
  echo "Choose only one quality flag: m, a, or l."
  usage
  exit 2
fi

QUALITY_FLAG="-m"
if [[ "$MODE" == *a* ]]; then
  QUALITY_FLAG="--hd"
elif [[ "$MODE" == *l* ]]; then
  QUALITY_FLAG="-l"
fi

IMAGE_MODE=0
if [[ "$MODE" == *i* ]]; then
  IMAGE_MODE=1
fi

if [[ -x "$SCRIPT_DIR/../venv/bin/manimgl" ]]; then
  MANIMGL="$SCRIPT_DIR/../venv/bin/manimgl"
else
  MANIMGL="${MANIMGL:-manimgl}"
fi

mkdir -p "$OUTPUT_DIR"

render_args=("$QUALITY_FLAG" "-w" "--video_dir" "$OUTPUT_DIR")
output_ext="mp4"
if (( IMAGE_MODE )); then
  render_args=("$QUALITY_FLAG" "-s" "-w" "--video_dir" "$OUTPUT_DIR")
  output_ext="png"
fi

folders=(
  "notes_21_apr"
  "notes_7_apr"
  "optimization"
)

should_skip_file() {
  local rel_file="$1"
  [[ "$rel_file" == "notes_21_apr/_01_lines_3d.py" ]]
}

total_files=0
for folder in "${folders[@]}"; do
  for file in "$SCRIPT_DIR/$folder"/*.py; do
    [[ -e "$file" ]] || continue
    rel_file="${file#$SCRIPT_DIR/}"
    should_skip_file "$rel_file" && continue
    total_files=$((total_files + 1))
  done
done

if (( total_files == 0 )); then
  echo "No Python scene files found."
  exit 1
fi

echo "Working directory: $SCRIPT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Mode: $MODE"
echo "Renderer: $MANIMGL"
echo "Files: $total_files"
echo

failures=()

for folder in "${folders[@]}"; do
  folder_path="$SCRIPT_DIR/$folder"
  folder_output_dir="$OUTPUT_DIR/$folder"
  folder_file_count=0

  for file in "$folder_path"/*.py; do
    [[ -e "$file" ]] || continue
    rel_file="${file#$SCRIPT_DIR/}"
    should_skip_file "$rel_file" && continue
    folder_file_count=$((folder_file_count + 1))
  done

  if (( folder_file_count == 0 )); then
    continue
  fi

  echo "---- Rendering folder: $folder ($folder_file_count files) ----"
  echo

  for file in "$folder_path"/*.py; do
    [[ -e "$file" ]] || continue

    stem="$(basename "$file" .py)"
    rel_file="${file#$SCRIPT_DIR/}"
    if should_skip_file "$rel_file"; then
      echo "==> Skipping $rel_file (ManimCE scene, not ManimGL)"
      echo
      continue
    fi

    echo "==> Rendering $rel_file -> render_finish/$stem.$output_ext"
    if "$MANIMGL" "$rel_file" "${render_args[@]}" --file_name "$stem"; then
      echo "    OK: $stem.$output_ext"
    else
      echo "    FAILED: $rel_file"
      failures+=("$rel_file")
    fi
    echo
  done

  mkdir -p "$folder_output_dir"
  moved_count=0
  for output_file in "$OUTPUT_DIR"/*."$output_ext"; do
    [[ -e "$output_file" ]] || continue
    mv -f "$output_file" "$folder_output_dir/"
    moved_count=$((moved_count + 1))
  done

  echo "Moved $moved_count .$output_ext files to render_finish/$folder/"
  echo
done

if (( ${#failures[@]} > 0 )); then
  echo "Some renders failed:"
  for failed in "${failures[@]}"; do
    echo "  - $failed"
  done
  exit 1
fi

echo "All renders finished in: $OUTPUT_DIR"
