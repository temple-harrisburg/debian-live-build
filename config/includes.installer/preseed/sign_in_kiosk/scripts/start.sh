#!/usr/bin/env bash

# Disable screensaver, screen blanking, and power management
xset s off
xset s noblank
xset -dpms

# Start server
cd "${HOME}/sign-in-kiosk" || exit 1
pnpm start &

# Start Chromium
chromium --kiosk --disable-gpu --noerrdialogs --disable-infobars --disable-features=TranslateUI \
    --disable-session-crashed-bubble --no-sandbox --disable-notifications --disable-sync-preferences \
    --disable-background-mode --disable-popup-blocking --no-first-run --password-store=basic \
    --enable-gpu-rasterization --disable-translate --disable-logging --disable-default-apps \
    --disable-extensions --disable-crash-reporter --disable-pdf-extension --disable-new-tab-first-run \
    --disable-dev-shm-usage --start-maximized --mute-audio --disable-crashpad --hide-scrollbars \
    --ash-hide-cursor --memory-pressure-off --force-device-scale-factor=1 --window-position=0,0 \
    "http://localhost:8080" &