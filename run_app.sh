#!/bin/bash
# Script to run the app using the local Flutter SDK

# Ensure we are in the project directory
cd "$(dirname "$0")"

# Path to the local Flutter SDK (relative to mind_over_meds)
FLUTTER_BIN="../flutter/bin/flutter"

# Add Homebrew bin to PATH for CocoaPods
export PATH="/opt/homebrew/bin:$PATH"

echo "Using Flutter SDK at: $FLUTTER_BIN"
$FLUTTER_BIN run -d macos
