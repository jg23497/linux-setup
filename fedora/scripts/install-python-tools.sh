#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="python-tools"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

packages=()

if ! rpm -q python3-pip >/dev/null 2>&1; then
    packages+=(python3-pip)
fi

if ! rpm -q pipx >/dev/null 2>&1; then
    packages+=(pipx)
fi

if ((${#packages[@]} == 0)); then
    log "python3-pip and pipx are already installed; skipping"
    exit 0
fi

log "Installing ${packages[*]}"
sudo dnf install -y "${packages[@]}"
log "Python tooling installation finished"
