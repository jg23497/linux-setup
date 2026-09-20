#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="kaddressbook"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if ! rpm -q kaddressbook >/dev/null 2>&1; then
    log "KAddressBook is not installed; skipping"
    exit 0
fi

log "Uninstalling KAddressBook"
sudo dnf remove -y kaddressbook
log "KAddressBook uninstallation finished"
