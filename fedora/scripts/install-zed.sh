#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SETTINGS_URL="https://raw.githubusercontent.com/jg23497/dotfiles/main/zed/settings.json"
readonly SETTINGS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zed"
readonly SETTINGS_FILE="$SETTINGS_DIR/settings.json"
LOG_CONTEXT="zed"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if command -v zed >/dev/null 2>&1 || [[ -x $HOME/.local/bin/zed ]]; then
    log "Zed is already installed; skipping installation"
else
    log "Installing Zed"
    curl -fsSL https://zed.dev/install.sh | sh
    log "Zed installation finished"
fi

if command -v git >/dev/null 2>&1; then
    log "Setting Zed as Git's editor"
    git config --global core.editor "zed --wait"
else
    log "Git is not installed; skipping Git editor configuration"
fi

log "Downloading Zed settings"
mkdir -p -- "$SETTINGS_DIR"
temporary_settings="$(mktemp "$SETTINGS_DIR/settings.json.XXXXXX")"
trap 'rm -f -- "$temporary_settings"' EXIT
curl -fsSL "$SETTINGS_URL" -o "$temporary_settings"
mv -f -- "$temporary_settings" "$SETTINGS_FILE"
trap - EXIT
log "Applied Zed settings to $SETTINGS_FILE"
