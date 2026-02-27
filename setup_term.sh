#!/bin/bash

set -e

echo "Installing JetBrainsMono Nerd Font..."

# Download the font
wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

# Create fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Unzip to fonts directory
unzip -q JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono

# Update font cache
echo "Updating font cache..."
fc-cache -fv > /dev/null 2>&1

# Clean up
rm JetBrainsMono.zip

echo "Font installed successfully!"

# Verify font installation
if fc-list | grep -qi jetbrains; then
    echo "✓ JetBrainsMono Nerd Font verified"
else
    echo "⚠ Warning: Font may not be installed correctly"
fi

# Import GNOME Terminal profiles
echo "Importing GNOME Terminal profiles..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/gnome-profiles.dconf" ]; then
    dconf load /org/gnome/terminal/legacy/profiles:/ < "$SCRIPT_DIR/gnome-profiles.dconf"
    echo "✓ Terminal profiles imported successfully!"
else
    echo "⚠ Warning: gnome-profiles.dconf not found in $SCRIPT_DIR"
    exit 1
fi

echo ""
echo "Setup complete! Restart GNOME Terminal to see the changes."
