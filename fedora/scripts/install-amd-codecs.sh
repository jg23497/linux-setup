#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="amd-codecs"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

packages_swapped=0

if rpm -q mesa-va-drivers >/dev/null 2>&1; then
    log "Installing AMD VA-API hardware-accelerated codecs"
    sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
    packages_swapped=1
fi

if rpm -q mesa-vdpau-drivers >/dev/null 2>&1; then
    log "Installing AMD VDPAU hardware-accelerated codecs"
    sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y
    packages_swapped=1
fi

if ((packages_swapped == 0)); then
    log "AMD hardware-accelerated codecs are already installed or not applicable; skipping"
else
    log "AMD hardware-accelerated codecs installation finished"
fi
