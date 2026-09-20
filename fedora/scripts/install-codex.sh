#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="codex"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if command -v codex >/dev/null 2>&1 || [[ -x $HOME/.local/bin/codex ]]; then
    log "Codex is already installed; skipping"
    exit 0
fi

log "Installing Codex"
curl -fsSL https://chatgpt.com/codex/install.sh | sh
log "Codex installation finished"
