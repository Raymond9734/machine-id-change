#!/bin/bash

# Auto-install/upgrade Cursor from the latest AppImage in ~/Downloads

set -e

DOWNLOADS_DIR="$HOME/Downloads"
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
APPIMAGE_TARGET="$INSTALL_DIR/cursor.AppImage"
ICON_NAME="cursor"
ICON_PATH="$HOME/.local/share/icons/${ICON_NAME}.png"

# Find latest Cursor AppImage using regex + version sort
echo "🔍 Searching for Cursor AppImage in $DOWNLOADS_DIR..."

APPIMAGE_PATH=$(find "$DOWNLOADS_DIR" -maxdepth 1 -type f -regex ".*/Cursor-[0-9]+\.[0-9]+\.[0-9]+-x86_64\.AppImage" \
  | sort -V | tail -n 1)

if [[ -z "$APPIMAGE_PATH" ]]; then
  echo "❌ No Cursor AppImage found in $DOWNLOADS_DIR."
  exit 1
fi

echo "📦 Found latest Cursor AppImage: $(basename "$APPIMAGE_PATH")"

# Prepare install directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$(dirname "$DESKTOP_FILE")"
mkdir -p "$(dirname "$ICON_PATH")"

# Move to install location
echo "🚚 Installing to $APPIMAGE_TARGET"
mv -f "$APPIMAGE_PATH" "$APPIMAGE_TARGET"
chmod +x "$APPIMAGE_TARGET"

# Try to extract icon
echo "🖼 Extracting icon..."
TEMP_DIR=$(mktemp -d)
"$APPIMAGE_TARGET" --appimage-extract > /dev/null 2>&1 || echo "⚠️ Skipping icon extraction"
ICON_CANDIDATE=$(find "$TEMP_DIR" -type f \( -iname "*.png" -o -iname "*.svg" \) | grep -Ei "cursor|code" | head -n 1)

if [[ -f "$ICON_CANDIDATE" ]]; then
  cp "$ICON_CANDIDATE" "$ICON_PATH"
  echo "✅ Icon copied to $ICON_PATH"
else
  echo "⚠️ No icon found. Using fallback icon name."
  ICON_PATH=$ICON_NAME
fi

rm -rf "$TEMP_DIR"

# Create or update desktop entry
echo "🖥 Creating/updating desktop shortcut..."

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Cursor
Exec=$APPIMAGE_TARGET
Icon=$ICON_PATH
Type=Application
Categories=Development;IDE;
StartupNotify=true
Terminal=false
EOF

chmod +x "$DESKTOP_FILE"
update-desktop-database "$(dirname "$DESKTOP_FILE")" > /dev/null 2>&1 || true

echo "✅ Cursor has been installed/updated and added to your app launcher."
