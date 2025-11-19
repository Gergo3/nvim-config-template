#!/bin/bash
# setup.sh - Customize template repository

set -e

# -----------------------------
# Functions
# -----------------------------
usage() {
    echo "Usage: $0 -l <language> [-b <base_image>]"
    exit 1
}

# -----------------------------
# Parse arguments
# -----------------------------
while getopts "l:b:" opt; do
    case $opt in
        l) LANGUAGE="$OPTARG" ;;
        b) BASE_IMAGE="$OPTARG" ;;
        *) usage ;;
    esac
done

# Check mandatory argument
if [ -z "$LANGUAGE" ]; then
    echo "Error: Programming language is required."
    usage
fi

# -----------------------------
# Detect repository name (optional)
# -----------------------------
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo ".")")

echo "Configuring repository '$REPO_NAME' for language '$LANGUAGE'..."

# -----------------------------
# Update README.md
# -----------------------------
    echo "# nvim-$LANGUAGE" > ./README.md
    echo "Updated README.md"

# -----------------------------
# Update Dockerfile if base image provided
# -----------------------------
if [ -n "$BASE_IMAGE" ] && [ -f "./Dockerfile" ]; then
    # Replace the line starting with FROM
    sed -i.bak "s|^FROM .*|FROM $BASE_IMAGE|" ./Dockerfile
    echo "Updated Dockerfile with base image '$BASE_IMAGE'"
elif [ -n "$BASE_IMAGE" ]; then
    echo "Warning: Dockerfile not found, cannot set base image."
fi

echo "Setup complete!"

# -----------------------------
# Self-delete
# -----------------------------
rm -- "$0"
