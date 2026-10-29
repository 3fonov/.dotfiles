#!/bin/bash
set -euo pipefail

REMOTE="yandex:Backup"
ICLOUD_REMOTE="icloud:"

FOLDERS=(
  "$HOME/Documents/1_Projects"
  "$HOME/Documents/2_Areas"
  "$HOME/Documents/config"
  "$HOME/Documents/4_Archive"
  "$HOME/.dotfiles"
  "$HOME/.ansible"
)

# Ignore file is expected alongside this script:
#
#   sync-ya-disk.sh
#   sync-ya-disk-ignore.txt
#
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IGNORE_FILE="$SCRIPT_DIR/sync-ya-disk-ignore.txt"


# ============================================================
# ARGUMENTS
# ============================================================

DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=true
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            echo "Usage: $0 [--dry-run]" >&2
            exit 1
            ;;
    esac
done


# ============================================================
# CHECKS
# ============================================================

if ! command -v rclone >/dev/null 2>&1; then
    echo "ERROR: rclone is not installed." >&2
    exit 1
fi

if [[ ! -f "$IGNORE_FILE" ]]; then
    echo "ERROR: ignore file not found:" >&2
    echo "  $IGNORE_FILE" >&2
    exit 1
fi


# ============================================================
# INFO
# ============================================================

echo "Yandex Disk backup"
echo "=================="
echo
echo "Remote:      $REMOTE"
echo "Ignore file: $IGNORE_FILE"

if [[ "$DRY_RUN" == true ]]; then
    echo "Mode:        DRY RUN"
else
    echo "Mode:        SYNC"
fi

echo


# ============================================================
# SYNC
# ============================================================

for SOURCE in "${FOLDERS[@]}"; do

    if [[ ! -d "$SOURCE" ]]; then
        echo
        echo "WARNING: directory does not exist:"
        echo "  $SOURCE"
        echo "Skipping."
        continue
    fi

    NAME="$(basename "$SOURCE")"
    DESTINATION="$REMOTE/$NAME"

    echo
    echo "============================================================"
    echo "$NAME"
    echo "============================================================"
    echo "Source:"
    echo "  $SOURCE"
    echo
    echo "Destination:"
    echo "  $DESTINATION"
    echo

    RCLONE_ARGS=(
        sync
        "$SOURCE"
        "$DESTINATION"
        --exclude-from "$IGNORE_FILE"
        --progress
        --stats 5s
        --stats-one-line
        --human-readable
    )

    if [[ "$DRY_RUN" == true ]]; then
        RCLONE_ARGS+=(--dry-run)
    fi

    rclone "${RCLONE_ARGS[@]}"

    echo
    echo "Finished: $NAME"
done



# ============================================================
# ICLOUD PHOTOS
# ============================================================

echo
echo "============================================================"
echo "Backing up iCloud Photos"
echo "============================================================"
echo "Source:      $ICLOUD_REMOTE"
echo "Destination: $REMOTE/iCloud Photos"

rclone copy \
    "$ICLOUD_REMOTE" \
    "$REMOTE/iCloud Photos" \
    --progress \
    --stats 5s \
    --stats-one-line \
    --human-readable \
    $([[ "$DRY_RUN" == true ]] && echo "--dry-run")

echo "Finished: iCloud Photos"

# ============================================================
# DONE
# ============================================================

echo
echo "============================================================"

if [[ "$DRY_RUN" == true ]]; then
    echo "Dry run completed. No files were changed."
else
    echo "Backup completed."
fi

echo "============================================================"
