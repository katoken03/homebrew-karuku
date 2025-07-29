# Karuku Homebrew Tap

This tap provides [Karuku](https://github.com/kato/karuku), an image optimization Electron app that automatically monitors directories and optimizes PNG files using pngquant.

## Installation

```bash
# Add the tap
brew tap kato/karuku

# Install Karuku
brew install --cask karuku
```

## Usage

After installation, Karuku will appear in your menu bar. You can:

- Configure directories to watch for PNG files
- Set up automatic image optimization
- View processing logs and statistics
- Manage pngquant dependencies

## Updating

```bash
# Update to the latest version
brew upgrade --cask karuku
```

## Uninstalling

```bash
# Remove the application
brew uninstall --cask karuku

# Remove all associated files (settings, logs, etc.)
brew uninstall --zap --cask karuku
```

## Supported Architectures

- **Apple Silicon (M1, M2, M3, M4)**: Native ARM64 binary
- **Intel Macs**: Native x64 binary

## Requirements

- macOS 11.0 (Big Sur) or later
- Homebrew installed

## About Karuku

Karuku is a powerful image optimization tool that:

- Monitors specified directories for new PNG files
- Automatically optimizes images using pngquant
- Provides real-time notifications and logs
- Supports both Apple Silicon and Intel Macs natively
- Includes automatic pngquant installation and management

For more information, visit the [main repository](https://github.com/kato/karuku).

## Support

- [Issues](https://github.com/kato/karuku/issues) - Report bugs or request features
- [Documentation](https://github.com/kato/karuku#readme) - Full documentation

## License

Karuku is distributed under the same license as specified in the main repository.
