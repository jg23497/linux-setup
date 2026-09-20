#!/usr/bin/env bash
# Fedora post-install setup
#
# Usage:
#   Run as your normal user: ./setup.sh
#   The script prompts for sudo when system packages need to be installed.
#   Logs are written to ~/.local/state/fedora-setup/ by default.
#   It is safe to rerun; steps skip software that is already installed.

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/fedora-setup"
readonly LOG_FILE="$LOG_DIR/setup-$(date +%Y%m%d-%H%M%S).log"
LOG_CONTEXT="setup"

source "$SCRIPT_DIR/lib/logging.sh"

for command in dnf flatpak rpm sudo tee; do
    if ! command -v "$command" >/dev/null 2>&1; then
        log_error "required command is missing: $command"
        exit 1
    fi
done

mkdir -p -- "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

on_error() {
    local exit_code=$?
    log_error "command failed on line $1: $2 (exit code $exit_code)"
    log "See the full log at $LOG_FILE"
    exit "$exit_code"
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

if [[ $EUID -eq 0 ]]; then
    log_error "run this script as your normal user; it will use sudo when needed."
    exit 1
fi

readonly STEPS=(
    "uninstall-firefox.sh"
    "uninstall-kde-games.sh"
    "uninstall-kmail.sh"
    "uninstall-korganizer.sh"
    "uninstall-kaddressbook.sh"
    "uninstall-neochat.sh"
    "enable-rpm-fusion.sh"
    "install-multimedia-codecs.sh"
    "install-amd-codecs.sh"
    "install-git.sh"
    "install-cli-tools.sh"
    "install-codex.sh"
    "install-google-chrome.sh"
    "install-zed.sh"
    "install-audacity.sh"
    "install-python-tools.sh"
    "enable-flathub.sh"
    "install-libreoffice.sh"
    "install-vlc.sh"
    "install-spotify.sh"
    "install-gimp.sh"
    "install-inkscape.sh"
    "pin-kde-taskbar-apps.sh"
)

log "Starting Fedora post-install setup"
log "Logging output to $LOG_FILE"

for step in "${STEPS[@]}"; do
    log "Running $step"
    bash "$SCRIPT_DIR/scripts/$step"
    log "Completed $step"
done

log "Fedora post-install setup completed successfully"
