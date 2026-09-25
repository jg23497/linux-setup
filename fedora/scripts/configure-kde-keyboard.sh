#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="kde-keyboard"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if command -v kwriteconfig6 >/dev/null 2>&1; then
    readonly KWRITE_CONFIG="kwriteconfig6"
elif command -v kwriteconfig5 >/dev/null 2>&1; then
    readonly KWRITE_CONFIG="kwriteconfig5"
else
    log_error "kwriteconfig is required to configure KDE keyboard layouts"
    exit 1
fi

log "Configuring US and British KDE keyboard layouts"
"$KWRITE_CONFIG" --file kxkbrc --group Layout --key Use true
"$KWRITE_CONFIG" --file kxkbrc --group Layout --key LayoutList "us,gb"
"$KWRITE_CONFIG" --file kxkbrc --group Layout --key VariantList ","
"$KWRITE_CONFIG" --file kxkbrc --group Layout --key DisplayNames ","
log "KDE keyboard layouts configured"
