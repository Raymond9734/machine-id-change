#!/bin/bash

# Auto-install/upgrade Cursor from the latest AppImage in ~/Downloads
# Usage: ./install_cursor.sh [filename]

set -e

DOWNLOADS_DIR="$HOME/Downloads"
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
APPIMAGE_TARGET="$INSTALL_DIR/cursor.AppImage"
ICON_NAME="cursor"
ICON_PATH="$HOME/.local/share/icons/${ICON_NAME}.png"

# Check for input argument
if [[ -n "$1" ]]; then
  echo "📄 Using specified file: $1"
  APPIMAGE_PATH="$DOWNLOADS_DIR/$1"
  if [[ ! -f "$APPIMAGE_PATH" ]]; then
    echo "❌ File not found: $APPIMAGE_PATH"
    exit 1
  fi
else
  # No filename provided, search for latest matching file
  echo "🔍 Searching for latest Cursor .AppImage in $DOWNLOADS_DIR..."

  APPIMAGE_PATH=$(find "$DOWNLOADS_DIR" -maxdepth 1 -type f -iname "cursor*.AppImage" \
    | sort -V | tail -n 1)

  if [[ -z "$APPIMAGE_PATH" ]]; then
    echo "❌ No matching Cursor AppImage found in $DOWNLOADS_DIR."
    exit 1
  fi
  echo "📦 Found latest Cursor AppImage: $(basename "$APPIMAGE_PATH")"
fi

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
