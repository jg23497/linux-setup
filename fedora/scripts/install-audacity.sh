#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="audacity"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if rpm -q audacity >/dev/null 2>&1; then
    log "Audacity is already installed; skipping"
    exit 0
fi

log "Installing Audacity"
sudo dnf install -y audacity
log "Audacity installation finished"
