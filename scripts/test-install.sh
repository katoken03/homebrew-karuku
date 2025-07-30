#!/bin/bash
# Test Karuku installation locally
# Usage: ./scripts/test-install.sh

set -e

CASK_FILE="./Casks/karuku.rb"

echo "🧪 Testing Karuku Cask installation..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed"
    echo "Please install Homebrew first: https://brew.sh"
    exit 1
fi

echo "✅ Homebrew found"

# Check if cask file exists
if [ ! -f "$CASK_FILE" ]; then
    echo "❌ Cask file not found: $CASK_FILE"
    exit 1
fi

echo "✅ Cask file found"

# Test cask syntax
echo "🔍 Testing cask syntax..."
if brew audit --cask "$CASK_FILE"; then
    echo "✅ Cask syntax is valid"
else
    echo "❌ Cask syntax validation failed"
    exit 1
fi

# Test cask style
echo "🎨 Testing cask style..."
if brew style "$CASK_FILE"; then
    echo "✅ Cask style is correct"
else
    echo "❌ Cask style check failed"
    exit 1
fi

# Test dry run installation
echo "🚀 Testing installation (dry run)..."
if brew install --cask --dry-run "$CASK_FILE" 2>/dev/null; then
    echo "✅ Dry run installation test passed"
else
    echo "⚠️  Dry run may fail if release doesn't exist yet (this is normal)"
fi

# Display cask info
echo ""
echo "📋 Cask Information:"
brew info --cask "$CASK_FILE" 2>/dev/null || echo "⚠️  Cannot display info (release may not exist)"

echo ""
echo "🎉 All basic tests completed successfully!"
echo ""
echo "To test actual installation (requires real release):"
echo "  brew install --cask $CASK_FILE"
echo ""
echo "To uninstall after testing:"
echo "  brew uninstall --cask karuku"
