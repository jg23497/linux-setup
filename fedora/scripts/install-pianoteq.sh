#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly DOWNLOADS_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
readonly INSTALL_DIR="$HOME/.local/opt/pianoteq"
readonly AUDIO_LIMITS_FILE="/etc/security/limits.d/99-pianoteq.conf"
LOG_CONTEXT="pianoteq"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if [[ ! -d $DOWNLOADS_DIR ]]; then
    log "WARNING: Downloads directory does not exist; skipping Pianoteq installation"
    exit 0
fi

archive=""
archive_mtime=-1

while IFS= read -r -d '' candidate; do
    candidate_mtime="$(stat -c '%Y' -- "$candidate")"
    if ((candidate_mtime > archive_mtime)); then
        archive="$candidate"
        archive_mtime="$candidate_mtime"
    fi
done < <(find "$DOWNLOADS_DIR" -type f -iname '*pianoteq*.7z' -print0)

if [[ -z $archive ]]; then
    log "WARNING: No Pianoteq .7z archive found under $DOWNLOADS_DIR; skipping Pianoteq installation"
    exit 0
fi

if ! command -v 7z >/dev/null 2>&1; then
    log_error "7z is required; run install-cli-tools.sh first"
    exit 1
fi

archive_checksum="$(sha256sum -- "$archive" | cut -d ' ' -f 1)"
checksum_file="$INSTALL_DIR/.source-archive.sha256"

if [[ -f $checksum_file ]] && [[ $(<"$checksum_file") == "$archive_checksum" ]]; then
    log "Pianoteq is already installed from $(basename -- "$archive"); skipping extraction"
else
    mkdir -p -- "$INSTALL_DIR"

    log "Extracting $(basename -- "$archive")"
    7z x -y -o"$INSTALL_DIR" -- "$archive" >/dev/null
    printf '%s\n' "$archive_checksum" >"$checksum_file"

    log "Installed Pianoteq files to $INSTALL_DIR"
fi

# Audio configuration TL;DR:, dropouts, and page faults.
# Give audio-group applications real-time scheduling, elevated CPU priority, and
# permission to lock enough memory to reduce latency.
current_user="$(id -un)"
session_restart_required=false

if ! getent group audio >/dev/null; then
    log "Creating the audio group"
    sudo groupadd --system audio
fi

if [[ " $(id -nG "$current_user") " != *" audio "* ]]; then
    log "Adding $current_user to the audio group"
    sudo usermod -aG audio "$current_user"
    session_restart_required=true
else
    log "$current_user is already a member of the audio group"
fi

audio_limits=$'@audio - rtprio 90\n@audio - nice -10\n@audio - memlock 500000\n'
if [[ -f $AUDIO_LIMITS_FILE ]] && cmp -s <(printf '%s' "$audio_limits") "$AUDIO_LIMITS_FILE"; then
    log "Pianoteq real-time audio limits are already configured"
else
    log "Configuring real-time audio limits in $AUDIO_LIMITS_FILE"
    printf '%s' "$audio_limits" | sudo tee "$AUDIO_LIMITS_FILE" >/dev/null
    session_restart_required=true
fi

if [[ $session_restart_required == true ]]; then
    log "Log out and back in before running Pianoteq so the audio limits take effect"
fi
