#!/bin/bash
# apply-patch-safe.sh — Reject-proof patch application for KernelSU-Next patches
# (50_add_susfs_in_gki, 51_enhanced_susfs, 60_zeromount, 70_ksu_safety).
#
# The static .patch files are generated against a specific android15-6.6
# sublevel. As the kernel-common source advances (e.g. 6.6.118), unrelated
# upstream churn shifts context lines and can turn a clean hunk into a
# ".rej" reject — silently dropping ZeroMount / SUSFS Kstat Redirect code
# (and therefore KernelSU-Next root) even though the build itself succeeds.
#
# This wrapper:
#   1. Dry-runs the patch at increasing fuzz levels (0..5) and applies the
#      LOWEST fuzz level that produces ZERO rejected hunks.
#   2. Verifies (again) that the real apply produced no .rej files.
#   3. Hard-fails with a clear diagnostic if no fuzz level applies cleanly,
#      instead of silently continuing with a partially-applied source tree.
#
# Usage: apply-patch-safe.sh <patch_file> [working_dir] [strip_level]
set -euo pipefail

PATCH_FILE="${1:?Usage: apply-patch-safe.sh <patch_file> [working_dir] [strip_level]}"
WORK_DIR="${2:-.}"
STRIP="${3:-1}"

if [ ! -s "$PATCH_FILE" ]; then
  echo "apply-patch-safe: ERROR: patch file '$PATCH_FILE' missing or empty" >&2
  exit 1
fi

cd "$WORK_DIR"

find . -name '*.rej' -delete 2>/dev/null || true

APPLIED=0
for FUZZ in 0 1 2 3 4 5; do
  if patch -p"$STRIP" -F"$FUZZ" --no-backup-if-mismatch --dry-run \
      < "$PATCH_FILE" > /dev/null 2>&1; then
    echo "apply-patch-safe: $(basename "$PATCH_FILE") applies cleanly at fuzz=$FUZZ"
    patch -p"$STRIP" -F"$FUZZ" --no-backup-if-mismatch < "$PATCH_FILE"
    APPLIED=1
    break
  fi
done

if [ "$APPLIED" -ne 1 ]; then
  echo "apply-patch-safe: FATAL: $(basename "$PATCH_FILE") cannot be applied cleanly (fuzz 0-5 all reject) against this kernel source." >&2
  echo "apply-patch-safe: refusing to continue — a broken ZeroMount/SUSFS apply would silently disable KernelSU-Next root." >&2
  exit 1
fi

# Belt-and-braces: even a "successful" patch run can leave partial .rej
# files behind if only some hunks in a multi-file patch failed.
mapfile -t REJECTS < <(find . -name '*.rej' 2>/dev/null)
if [ "${#REJECTS[@]}" -gt 0 ]; then
  echo "apply-patch-safe: FATAL: $(basename "$PATCH_FILE") left ${#REJECTS[@]} reject file(s):" >&2
  printf '  %s\n' "${REJECTS[@]}" >&2
  exit 1
fi

echo "apply-patch-safe: $(basename "$PATCH_FILE") applied with 0 rejects"
