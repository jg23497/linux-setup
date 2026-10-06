#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="development-tools"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

packages=()

for package in gh make npm; do
    if ! rpm -q "$package" >/dev/null 2>&1; then
        packages+=("$package")
    fi
done

if ((${#packages[@]} == 0)); then
    log "Development tools are already installed; skipping"
    exit 0
fi

log "Installing development tools: ${packages[*]}"
sudo dnf install -y "${packages[@]}"
log "Development tools installation finished"
