#!/bin/bash
# Auto-sync preview to GitHub Pages repo

SOURCE="/Users/hkitsinian/kitsinian-legal-app/preview/index.html"
DEST="/Users/hkitsinian/claimit-preview/index.html"

if [ -f "$SOURCE" ]; then
    cp "$SOURCE" "$DEST"
    echo "✅ Synced preview to claimit-preview"
else
    echo "❌ Source file not found: $SOURCE"
    exit 1
fi
