#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="firefox"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if ! rpm -q firefox >/dev/null 2>&1; then
    log "Firefox is not installed; skipping"
    exit 0
fi

log "Uninstalling Firefox"
sudo dnf remove -y firefox
log "Firefox uninstallation finished"
