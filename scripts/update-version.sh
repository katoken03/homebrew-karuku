#!/bin/bash
# Karuku version update script
# Usage: ./scripts/update-version.sh <version>

set -e

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 1.1.0"
  exit 1
fi

echo "🔄 Updating Karuku to version $VERSION..."

# GitHub repository info
REPO="katoken03/karuku"
CASK_FILE="Casks/karuku.rb"

# Download URLs
ARM64_URL="https://github.com/$REPO/releases/download/v$VERSION/Karuku-$VERSION-arm64.dmg"
INTEL_URL="https://github.com/$REPO/releases/download/v$VERSION/Karuku-$VERSION-x64.dmg"

echo "📥 Calculating SHA256 hashes..."

# Calculate SHA256 hashes
echo "Downloading ARM64 version..."
ARM64_SHA=$(curl -sL "$ARM64_URL" | shasum -a 256 | cut -d' ' -f1)
if [ -z "$ARM64_SHA" ]; then
    echo "❌ Failed to download or calculate SHA256 for ARM64 version"
    exit 1
fi
echo "ARM64 SHA256: $ARM64_SHA"

echo "Downloading Intel version..."
INTEL_SHA=$(curl -sL "$INTEL_URL" | shasum -a 256 | cut -d' ' -f1)
if [ -z "$INTEL_SHA" ]; then
    echo "❌ Failed to download or calculate SHA256 for Intel version"
    exit 1
fi
echo "Intel SHA256: $INTEL_SHA"

echo "📝 Updating Cask file..."

# Create temporary file for updates
TEMP_FILE=$(mktemp)

# Update the Cask file
cat > "$TEMP_FILE" << EOF
cask "karuku" do
  arch arm: "arm64", intel: "x64"
  
  on_arm do
    version "$VERSION"
    sha256 "$ARM64_SHA"
  end
  
  on_intel do
    version "$VERSION" 
    sha256 "$INTEL_SHA"
  end
  
  url "https://github.com/$REPO/releases/download/v#{version}/Karuku-#{version}-#{arch}.dmg"
  
  name "Karuku"
  desc "Image optimization Electron app with automatic directory monitoring"
  homepage "https://github.com/$REPO"
  
  # 最小macOSバージョン
  depends_on macos: ">= :big_sur"
  
  app "Karuku.app"
  
  # アンインストール時の処理
  uninstall quit: "com.katoken03.karuku"
  
  # 完全削除時のクリーンアップ
  zap trash: [
    "~/Library/Application Support/Karuku",
    "~/Library/Preferences/com.katoken03.karuku.plist",
    "~/Library/Logs/Karuku",
    "~/Library/Caches/com.katoken03.karuku"
  ]
end
EOF

# Replace the original file
mv "$TEMP_FILE" "$CASK_FILE"

echo "✅ Successfully updated $CASK_FILE to version $VERSION"
echo "📋 Summary:"
echo "  Version: $VERSION"
echo "  ARM64 SHA256: $ARM64_SHA"
echo "  Intel SHA256: $INTEL_SHA"
