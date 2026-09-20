#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="gimp"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if rpm -q gimp >/dev/null 2>&1; then
    log "GIMP is already installed; skipping"
    exit 0
fi

log "Installing GIMP"
sudo dnf install -y gimp
log "GIMP installation finished"
