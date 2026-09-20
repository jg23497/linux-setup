#!/usr/bin/env bash

set -Eeuo pipefail

readonly FEDORA_SETUP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_CONTEXT="kde-taskbar"

source "$FEDORA_SETUP_DIR/lib/logging.sh"

desktop_session="${XDG_CURRENT_DESKTOP:-}:${XDG_SESSION_DESKTOP:-}:${DESKTOP_SESSION:-}"
desktop_session="${desktop_session,,}"

if [[ $desktop_session != *kde* && $desktop_session != *plasma* ]]; then
    log "KDE Plasma is not the active desktop; skipping taskbar configuration"
    exit 0
fi

if ! command -v gdbus >/dev/null 2>&1; then
    log_error "gdbus is required to configure the KDE Plasma taskbar"
    exit 1
fi

if ! gdbus introspect \
    --session \
    --dest org.kde.plasmashell \
    --object-path /PlasmaShell >/dev/null 2>&1; then
    log "KDE Plasma is not running in this session; skipping taskbar configuration"
    exit 0
fi

readonly PLASMA_SCRIPT='
function pinLauncher(launchers, launcher, aliases) {
    var insertionIndex = launchers.length;

    for (var i = launchers.length - 1; i >= 0; --i) {
        if (launchers[i] === launcher || aliases.indexOf(launchers[i]) !== -1) {
            insertionIndex = i;
            launchers.splice(i, 1);
        }
    }

    launchers.splice(insertionIndex, 0, launcher);
}

var panelList = panels();

for (var panelIndex = 0; panelIndex < panelList.length; ++panelIndex) {
    var widgetList = panelList[panelIndex].widgets();

    for (var widgetIndex = 0; widgetIndex < widgetList.length; ++widgetIndex) {
        var widget = widgetList[widgetIndex];

        if (widget.type !== "org.kde.plasma.icontasks" &&
            widget.type !== "org.kde.plasma.taskmanager") {
            continue;
        }

        widget.currentConfigGroup = ["General"];

        var configuredLaunchers = String(widget.readConfig("launchers", ""));
        var launchers = configuredLaunchers === "" ? [] : configuredLaunchers.split(",");

        pinLauncher(
            launchers,
            "applications:google-chrome.desktop",
            ["preferred://browser"]
        );
        pinLauncher(
            launchers,
            "applications:com.spotify.Client.desktop",
            []
        );
        pinLauncher(
            launchers,
            "applications:org.kde.konsole.desktop",
            ["preferred://terminal"]
        );

        widget.writeConfig("launchers", launchers);
        widget.reloadConfig();
    }
}
'

log "Pinning Google Chrome, Spotify, and Konsole to the KDE taskbar"
gdbus call \
    --session \
    --dest org.kde.plasmashell \
    --object-path /PlasmaShell \
    --method org.kde.PlasmaShell.evaluateScript \
    "$PLASMA_SCRIPT" >/dev/null
log "KDE taskbar applications pinned"
