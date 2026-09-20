#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="git"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if command -v git >/dev/null 2>&1; then
    log "Git is already installed; skipping"
else
    log "Installing Git"
    sudo dnf install -y git-core
    log "Git installation finished"
fi

log "Setting Git's default initial branch to main"
git config --global init.defaultBranch main
log "Git configuration finished"
