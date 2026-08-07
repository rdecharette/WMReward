#!/usr/bin/env bash
set -euo pipefail

# Run from this repository regardless of the caller's working directory.
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Override VIDEO to score a different file, for example:
# VIDEO=/path/to/video.mp4 ./test_vith.sh
VIDEO="${VIDEO:-../physics-sim/output/sims/v4_bis/dl3dv/random/5/c-1_no-5_d-10_s-dl3dv-all_models-hf-gso_MLP-10_smooth_h-10-40_seed-112_20260428_144954/_fps-25_render.mp4}"
MAXFRAMES="${MAXFRAMES:-150}"
WINDOW_SIZE="${WINDOW_SIZE:-16}"
STRIDE="${STRIDE:-8}"
CONTEXT_FRAMES="${CONTEXT_FRAMES:-8}"
MODE="${MODE:-mean}"
command -v python >/dev/null 2>&1 || {
  echo "Error: python was not found in PATH. Activate the target environment before running." >&2
  exit 1
}

# [[ "$MODE" == "mean" || "$MODE" == "max" ]] || {
#   echo "Error: MODE must be one of: mean, max (got: $MODE)" >&2
#   exit 1
# }

[[ -f "$VIDEO" ]] || {
  echo "Error: input video not found: $VIDEO" >&2
  exit 1
}

PYTHONUNBUFFERED=1 python -u compute_wmreward.py \
  --video_path "$VIDEO" \
  --model vith \
  --window_size "$WINDOW_SIZE" \
  --context_frames "$CONTEXT_FRAMES" \
  --max_frames "$MAXFRAMES" \
  --stride "$STRIDE" \
  --mode "$MODE"
