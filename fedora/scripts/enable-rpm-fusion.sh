#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly FEDORA_VERSION="$(rpm -E %fedora)"
LOG_CONTEXT="rpm-fusion"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

log "Enabling RPM Fusion repositories"
sudo dnf install -y \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm"
sudo dnf install -y \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

log "Updating Fedora core packages"
sudo dnf update @core -y
log "RPM Fusion repositories enabled"
