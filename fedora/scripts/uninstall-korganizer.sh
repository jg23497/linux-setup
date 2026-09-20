#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="korganizer"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if ! rpm -q korganizer >/dev/null 2>&1; then
    log "KOrganizer is not installed; skipping"
    exit 0
fi

log "Uninstalling KOrganizer"
sudo dnf remove -y korganizer
log "KOrganizer uninstallation finished"
