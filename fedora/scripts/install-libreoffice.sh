#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="libreoffice"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

log "Removing RPM-packaged LibreOffice components"
sudo dnf remove -y 'libreoffice*'

log "Installing LibreOffice from Flathub"
flatpak install -y flathub org.libreoffice.LibreOffice
log "LibreOffice installation finished"
