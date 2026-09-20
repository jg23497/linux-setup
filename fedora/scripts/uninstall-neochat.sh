#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="neochat"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if ! rpm -q neochat >/dev/null 2>&1; then
    log "NeoChat is not installed; skipping"
    exit 0
fi

log "Uninstalling NeoChat"
sudo dnf remove -y neochat
log "NeoChat uninstallation finished"
