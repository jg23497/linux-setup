#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="python-tools"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

packages=()

if ! rpm -q python3-pip >/dev/null 2>&1; then
    packages+=(python3-pip)
fi

for package in pipx uv; do
    if ! rpm -q "$package" >/dev/null 2>&1; then
        packages+=("$package")
    fi
done

if ((${#packages[@]} == 0)); then
    log "Python tooling is already installed; skipping"
    exit 0
fi

log "Installing ${packages[*]}"
sudo dnf install -y "${packages[@]}"
log "Python tooling installation finished"
