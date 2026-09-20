#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly FLATHUB_REPOSITORY_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"
LOG_CONTEXT="flathub"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

log "Enabling the Flathub remote"
flatpak remote-add --if-not-exists flathub "$FLATHUB_REPOSITORY_URL"
log "Flathub remote enabled"
