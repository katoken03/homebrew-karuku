# Installation Guide

## Quick Start

```bash
# Add the Karuku tap
brew tap katoken03/karuku

# Install Karuku
brew install --cask karuku
```

## Detailed Installation Steps

### 1. Prerequisites

- macOS 11.0 (Big Sur) or later
- Homebrew installed ([Installation Guide](https://brew.sh))

### 2. Add the Tap

```bash
brew tap katoken03/karuku
```

This adds the Karuku repository to your Homebrew installation.

### 3. Install Karuku

```bash
brew install --cask karuku
```

Homebrew will automatically:
- Detect your Mac's architecture (Apple Silicon or Intel)
- Download the appropriate binary
- Install Karuku.app to your Applications folder
- Set up necessary permissions

### 4. Launch Karuku

After installation, you can:
- Find Karuku in your Applications folder
- Launch it like any other Mac application
- Look for the Karuku icon in your menu bar

## Architecture Support

Karuku provides native binaries for both architectures:

- **Apple Silicon Macs (M1, M2, M3, M4)**: ARM64 native binary
- **Intel Macs**: x64 native binary

Homebrew automatically selects the correct version for your Mac.

## Verification

To verify your installation:

```bash
# Check if Karuku is installed
brew list --cask | grep karuku

# Show installation details
brew info --cask karuku

# Verify the application exists
ls -la "/Applications/Karuku.app"
```

## Updating

```bash
# Update to the latest version
brew upgrade --cask karuku

# Check for available updates
brew outdated --cask
```

## Alternative Installation Methods

### Manual Installation from Cask File

If you want to test the latest development version:

```bash
# Clone this repository
git clone https://github.com/katoken03/homebrew-karuku.git

# Install from local cask file
brew install --cask ./homebrew-karuku/Casks/karuku.rb
```

### Direct Download

You can also download releases directly from the [main repository](https://github.com/katoken03/karuku/releases).

## Troubleshooting

### Common Issues

1. **"karuku cannot be opened because the developer cannot be verified"**
   - Right-click the app and select "Open"
   - Click "Open" in the security dialog
   - This only needs to be done once

2. **Installation fails with permission errors**
   - Ensure you're not using `sudo` with Homebrew commands
   - Check Homebrew permissions: `brew doctor`

3. **Wrong architecture installed**
   - Uninstall: `brew uninstall --cask karuku`
   - Clear cache: `brew cleanup`
   - Reinstall: `brew install --cask karuku`

### Getting Help

- [Main Repository Issues](https://github.com/katoken03/karuku/issues)
- [Homebrew Troubleshooting](https://docs.brew.sh/Troubleshooting)

## Next Steps

After installation:
1. Launch Karuku from Applications or menu bar
2. Configure directories to monitor
3. Set up image optimization preferences
4. Review the [main documentation](https://github.com/katoken03/karuku#readme)
