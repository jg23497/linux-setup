#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly DOWNLOADS_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
readonly INSTALL_ROOT="$HOME/.local/opt"
readonly INSTALL_DIR="$INSTALL_ROOT/REAPER"
readonly SOURCE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/linux-setup/reaper"
LOG_CONTEXT="reaper"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

if [[ ! -d $DOWNLOADS_DIR ]]; then
    log "WARNING: Downloads directory does not exist; skipping REAPER installation"
    exit 0
fi

case "$(uname -m)" in
    x86_64)
        archive_pattern='reaper*_linux_x86_64.tar.xz'
        ;;
    aarch64)
        archive_pattern='reaper*_linux_aarch64.tar.xz'
        ;;
    armv7l)
        archive_pattern='reaper*_linux_armv7l.tar.xz'
        ;;
    *)
        log_error "unsupported architecture: $(uname -m)"
        exit 1
        ;;
esac

archive=""
archive_mtime=-1

while IFS= read -r -d '' candidate; do
    candidate_mtime="$(stat -c '%Y' -- "$candidate")"
    if ((candidate_mtime > archive_mtime)); then
        archive="$candidate"
        archive_mtime="$candidate_mtime"
    fi
done < <(find "$DOWNLOADS_DIR" -type f -iname "$archive_pattern" -print0)

if [[ -z $archive ]]; then
    log "WARNING: No REAPER archive matching $archive_pattern found under $DOWNLOADS_DIR; skipping installation"
    exit 0
fi

for command in tar xdg-desktop-menu xdg-icon-resource xdg-mime; do
    if ! command -v "$command" >/dev/null 2>&1; then
        log_error "required command is missing: $command"
        exit 1
    fi
done

archive_checksum="$(sha256sum -- "$archive" | cut -d ' ' -f 1)"
source_checksum_file="$SOURCE_DIR/.source-archive.sha256"

if [[ ! -f $source_checksum_file ]] || [[ $(<"$source_checksum_file") != "$archive_checksum" ]]; then
    mkdir -p -- "$SOURCE_DIR"
    log "Extracting $(basename -- "$archive")"
    tar -xJf "$archive" -C "$SOURCE_DIR" --strip-components=1
    printf '%s\n' "$archive_checksum" >"$source_checksum_file"
else
    log "REAPER installer is already extracted from $(basename -- "$archive")"
fi

vendor_installer="$SOURCE_DIR/install-reaper.sh"
if [[ ! -f $vendor_installer ]]; then
    log_error "the REAPER archive does not contain install-reaper.sh"
    exit 1
fi

mkdir -p -- "$INSTALL_ROOT"
log "Running the bundled REAPER installer"
sh "$vendor_installer" \
    --install "$INSTALL_ROOT" \
    --integrate-user-desktop \
    --quiet

printf '%s\n' "$archive_checksum" >"$INSTALL_DIR/.source-archive.sha256"
log "Installed REAPER to $INSTALL_DIR with desktop integration"
