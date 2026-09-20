#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="spotify"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if flatpak info com.spotify.Client >/dev/null 2>&1; then
    log "Spotify is already installed; skipping"
    exit 0
fi

log "Installing Spotify"
flatpak install -y flathub com.spotify.Client
log "Spotify installation finished"
