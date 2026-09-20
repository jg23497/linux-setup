#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="inkscape"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if rpm -q inkscape >/dev/null 2>&1; then
    log "Inkscape is already installed; skipping"
    exit 0
fi

log "Installing Inkscape"
sudo dnf install -y inkscape
log "Inkscape installation finished"
