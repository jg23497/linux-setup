#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="google-chrome"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if rpm -q google-chrome-stable >/dev/null 2>&1; then
    log "Google Chrome is already installed; skipping"
    exit 0
fi

log "Installing Google Chrome stable"
sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
log "Google Chrome installation finished"
