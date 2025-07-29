#!/bin/bash
# Calculate SHA256 for Karuku releases
# Usage: ./scripts/calculate-sha256.sh <version> [architecture]

set -e

VERSION=$1
ARCH=$2

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version> [architecture]"
  echo "Architecture: arm64, x64, or 'both' (default)"
  echo "Example: $0 1.0.0 arm64"
  exit 1
fi

REPO="kato/karuku"

calculate_sha256() {
  local arch=$1
  local url="https://github.com/$REPO/releases/download/v$VERSION/Karuku-$VERSION-$arch.dmg"
  
  echo "🔍 Calculating SHA256 for $arch..."
  echo "📥 URL: $url"
  
  local sha256=$(curl -sL "$url" | shasum -a 256 | cut -d' ' -f1)
  
  if [ -z "$sha256" ]; then
    echo "❌ Failed to calculate SHA256 for $arch"
    return 1
  fi
  
  echo "✅ $arch SHA256: $sha256"
  return 0
}

case "$ARCH" in
  "arm64")
    calculate_sha256 "arm64"
    ;;
  "x64")
    calculate_sha256 "x64"
    ;;
  "both"|"")
    echo "📊 Calculating SHA256 for both architectures..."
    calculate_sha256 "arm64"
    echo ""
    calculate_sha256 "x64"
    ;;
  *)
    echo "❌ Invalid architecture: $ARCH"
    echo "Valid options: arm64, x64, both"
    exit 1
    ;;
esac

echo ""
echo "✅ SHA256 calculation completed for version $VERSION"
