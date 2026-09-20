#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="kde-games"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

readonly KDE_GAMES=(
    kmahjongg
    kmines
    kpat
)

installed_games=()

for package in "${KDE_GAMES[@]}"; do
    if rpm -q "$package" >/dev/null 2>&1; then
        installed_games+=("$package")
    fi
done

if ((${#installed_games[@]} == 0)); then
    log "Bundled KDE games are not installed; skipping"
    exit 0
fi

log "Uninstalling bundled KDE games: ${installed_games[*]}"
sudo dnf remove -y "${installed_games[@]}"
log "Bundled KDE games uninstallation finished"
