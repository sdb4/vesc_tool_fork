#!/bin/bash -e

#Current directory of the script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

#set -x
set -e

#./build_lin_original_only
convert -resize 128x128 res/version/free_v.svg vesc_tool_icon.png

# Define directories
binDir="appdir/usr/bin"
appDir="appdir/usr/share/applications"
iconDir="appdir/usr/share/icons/hicolor/128x128/apps"

# Create necessary directories
mkdir -p "$binDir" "$appDir" "$iconDir"

# Create the .desktop file
cat > "$appDir/vesc_tool.desktop" <<EOF
[Desktop Entry]
Name=VESC Tool
Exec=vesc_tool_6.06 %F
Icon=vesc_tool_icon
Terminal=true
Type=Application
Categories=Utility;Science;
EOF

# Copy the executable and icon
cp build/lin/vesc_tool_6.06 "$binDir"
cp vesc_tool_icon.png "$iconDir"

# Download linuxdeploy
#wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage --no-check-certificate -O linuxdeploy-aarch64.AppImage
#chmod +x linuxdeploy-aarch64.AppImage

# now, build AppImage using linuxdeploy and linuxdeploy-plugin-qt
# download linuxdeploy and its Qt plugin
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-aarch64.AppImage --no-check-certificate
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-aarch64.AppImage

# make them executable
chmod +x linuxdeploy-*.AppImage

# Patch
# https://github.com/AppImage/AppImageKit/issues/1027
dd if=/dev/zero of=linuxdeploy-aarch64.AppImage conv=notrunc bs=1 count=3 seek=8;

# Build the AppImage
./linuxdeploy-aarch64.AppImage --appimage-extract-and-run --appdir appdir --plugin qt --output appimage
#mv VESC_Tool-aarch64.AppImage vesc_tool_6.06

# Clean-up (uncomment these lines if clean-up is desired)
rm -rf appdir/
rm linuxdeploy-*.AppImage

#rsync -auzv VESC_Tool-aarch64.AppImage admin@192.168.153.1:
