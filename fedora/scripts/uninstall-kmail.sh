#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="kmail"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if ! rpm -q kmail >/dev/null 2>&1; then
    log "KMail is not installed; skipping"
    exit 0
fi

log "Uninstalling KMail"
sudo dnf remove -y kmail
log "KMail uninstallation finished"
