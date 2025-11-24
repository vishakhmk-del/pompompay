#!/bin/bash

# Load values from version.properties
VERSION_MAJOR=$(grep versionMajor version.properties | cut -d'=' -f2)
VERSION_MINOR=$(grep versionMinor version.properties | cut -d'=' -f2)
VERSION_PATCH=$(grep versionPatch version.properties | cut -d'=' -f2)

VERSION_NAME="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"
VERSION_CODE=$((VERSION_MAJOR * 10000 + VERSION_MINOR * 100 + VERSION_PATCH))

PLIST_PATH="ios/Runner/Info.plist"

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION_NAME" "$PLIST_PATH"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $VERSION_CODE" "$PLIST_PATH"

echo "✅ iOS Info.plist updated: version=$VERSION_NAME, build=$VERSION_CODE"
