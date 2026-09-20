#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="multimedia-codecs"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

log "Installing multimedia codecs"

if rpm -q ffmpeg-free >/dev/null 2>&1; then
    sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
elif ! rpm -q ffmpeg >/dev/null 2>&1; then
    sudo dnf install ffmpeg --allowerasing -y
else
    log "Full FFmpeg package is already installed; skipping swap"
fi

sudo dnf group install multimedia \
    --setopt="install_weak_deps=False" \
    --exclude=PackageKit-gstreamer-plugin \
    -y
sudo dnf group install sound-and-video -y

log "Multimedia codecs installation finished"
