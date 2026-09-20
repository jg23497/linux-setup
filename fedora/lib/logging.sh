#!/usr/bin/env bash

readonly LOG_GREEN=$'\033[0;32m'
readonly LOG_RESET=$'\033[0m'

# Set LOG_CONTEXT before sourcing this file to identify the calling script.
log() {
    local context="${LOG_CONTEXT:-setup}"
    printf '%s[%s] [%s] %s%s\n' \
        "$LOG_GREEN" "$(date '+%Y-%m-%d %H:%M:%S')" "$context" "$*" "$LOG_RESET"
}

log_error() {
    log "ERROR: $*" >&2
}
