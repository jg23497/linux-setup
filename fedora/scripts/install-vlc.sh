#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="vlc"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if rpm -q vlc >/dev/null 2>&1; then
    log "VLC is already installed; skipping"
    exit 0
fi

log "Installing VLC"
sudo dnf install -y vlc
log "VLC installation finished"
