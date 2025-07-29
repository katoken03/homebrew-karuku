# Troubleshooting

## Common Issues and Solutions

### Installation Issues

#### 1. "karuku cannot be opened because the developer cannot be verified"

**Symptoms:**
- macOS shows a security warning when launching Karuku
- The app appears to install but won't open

**Solution:**
```bash
# Option 1: Right-click method
# 1. Right-click Karuku.app in Applications
# 2. Select "Open" from context menu
# 3. Click "Open" in the security dialog

# Option 2: System Preferences method
# 1. Go to System Preferences > Security & Privacy
# 2. Click "Open Anyway" next to the Karuku warning
```

#### 2. Installation fails with SHA256 mismatch

**Symptoms:**
```
Error: SHA256 mismatch
Expected: abc123...
Actual: def456...
```

**Solution:**
```bash
# Clear Homebrew cache and retry
brew cleanup karuku
brew uninstall --cask karuku
brew install --cask karuku

# If problem persists, check if you have the latest tap
brew untap kato/karuku
brew tap kato/karuku
brew install --cask karuku
```

#### 3. Permission errors during installation

**Symptoms:**
- Installation fails with permission denied errors
- Homebrew requests sudo password

**Solution:**
```bash
# Never use sudo with Homebrew
# Check Homebrew installation health
brew doctor

# Fix common permission issues
sudo chown -R $(whoami) /usr/local/var/homebrew
sudo chown -R $(whoami) /opt/homebrew  # For Apple Silicon
```

#### 4. Wrong architecture installed

**Symptoms:**
- App runs but performance is poor (Rosetta emulation)
- Activity Monitor shows "Intel" for the process on Apple Silicon

**Solution:**
```bash
# Check current installation
brew info --cask karuku

# Reinstall with architecture detection
brew uninstall --cask karuku
brew cleanup
brew install --cask karuku

# Verify correct architecture
# On Apple Silicon: should show ARM64
# On Intel: should show Intel
```

### Runtime Issues

#### 5. Karuku doesn't appear in menu bar

**Symptoms:**
- App launches but no menu bar icon appears
- Cannot access Karuku settings

**Solution:**
```bash
# Check if app is actually running
ps aux | grep -i karuku

# Restart the app
pkill -f "Karuku"
open "/Applications/Karuku.app"

# Check menu bar settings
# System Preferences > Dock & Menu Bar > Menu Bar Items
```

#### 6. Image optimization not working

**Symptoms:**
- Files are detected but not optimized
- Error messages about pngquant

**Solution:**
```bash
# Check if pngquant is installed
which pngquant
brew list | grep pngquant

# Install pngquant if missing
brew install pngquant

# Check Karuku logs
# Open Karuku > Show Logs to see error details
```

#### 7. Directory monitoring not working

**Symptoms:**
- New PNG files are not detected
- No optimization occurs automatically

**Solution:**
```bash
# Check file system permissions
# System Preferences > Security & Privacy > Privacy > Full Disk Access
# Add Karuku.app to the list

# Restart directory monitoring
# In Karuku settings: disable and re-enable directory watching
```

### Update Issues

#### 8. Homebrew says "already installed" but version is old

**Symptoms:**
```bash
brew upgrade --cask karuku
# Warning: karuku 1.0.0 already installed
```

**Solution:**
```bash
# Force reinstall latest version
brew reinstall --cask karuku

# Or uninstall and reinstall
brew uninstall --cask karuku
brew install --cask karuku

# Check tap is up to date
brew update
brew upgrade --cask karuku
```

#### 9. Cannot find latest version

**Symptoms:**
- Homebrew shows older version than GitHub releases
- `brew search karuku` shows no results

**Solution:**
```bash
# Update Homebrew and taps
brew update

# Check tap status
brew tap kato/karuku

# Force tap update
brew untap kato/karuku
brew tap kato/karuku

# Verify latest version is available
brew info --cask karuku
```

### Uninstallation Issues

#### 10. App not completely removed

**Symptoms:**
- Settings and logs remain after uninstall
- App still appears in some locations

**Solution:**
```bash
# Complete removal (zap)
brew uninstall --zap --cask karuku

# Manual cleanup if needed
rm -rf ~/Library/Application\ Support/Karuku
rm -f ~/Library/Preferences/com.kato.karuku.plist
rm -rf ~/Library/Logs/Karuku
rm -rf ~/Library/Caches/com.kato.karuku
```

## Advanced Troubleshooting

### Debug Mode Installation

```bash
# Install with verbose output
brew install --cask karuku --verbose

# Check download and installation process
brew --cache --cask karuku
ls -la "$(brew --cache)/downloads"
```

### Log Analysis

```bash
# Homebrew logs
tail -f /opt/homebrew/var/log/brew.log  # Apple Silicon
tail -f /usr/local/var/log/brew.log     # Intel

# System logs for Karuku
log show --predicate 'process == "Karuku"' --last 1h
```

### Network Issues

```bash
# Test connectivity to GitHub releases
curl -I https://github.com/kato/karuku/releases/latest

# Check for proxy/firewall issues
brew --env | grep -i proxy
```

### Architecture Verification

```bash
# Check system architecture
uname -m
# arm64 = Apple Silicon
# x86_64 = Intel

# Check Homebrew architecture
brew config | grep CPU

# Check installed app architecture
file "/Applications/Karuku.app/Contents/MacOS/Karuku"
```

## Getting Help

### Before Reporting Issues

1. **Update everything:**
   ```bash
   brew update
   brew doctor
   brew upgrade --cask karuku
   ```

2. **Collect system information:**
   ```bash
   brew config
   brew --version
   sw_vers
   ```

3. **Try clean installation:**
   ```bash
   brew uninstall --zap --cask karuku
   brew cleanup
   brew install --cask karuku
   ```

### Where to Get Help

- **Karuku Issues**: [Main Repository Issues](https://github.com/kato/karuku/issues)
- **Homebrew Issues**: [Homebrew Troubleshooting](https://docs.brew.sh/Troubleshooting)
- **Tap Issues**: [Homebrew-Karuku Issues](https://github.com/kato/homebrew-karuku/issues)

### Information to Include in Bug Reports

When reporting issues, please include:

1. **System Information:**
   - macOS version (`sw_vers`)
   - Mac model and architecture
   - Homebrew version (`brew --version`)

2. **Homebrew Status:**
   ```bash
   brew config
   brew doctor
   ```

3. **Installation Details:**
   ```bash
   brew info --cask karuku
   brew list --cask | grep karuku
   ```

4. **Error Messages:**
   - Complete error output
   - Relevant log entries
   - Screenshots if applicable

5. **Steps to Reproduce:**
   - Exact commands used
   - Expected vs actual behavior

## FAQ

**Q: Why do I need to use `--cask` with the install command?**
A: Karuku is a macOS application (not a command-line tool), so it uses Homebrew Cask for installation.

**Q: Can I install both Intel and Apple Silicon versions?**
A: No, Homebrew automatically selects the correct architecture for your Mac.

**Q: How do I switch between different versions?**
A: Use `brew uninstall --cask karuku` then `brew install --cask karuku@<version>` (if version pins are available).

**Q: Is it safe to use with other package managers?**
A: Yes, but avoid installing the same app through multiple package managers to prevent conflicts.

**Q: How do I verify the installation is secure?**
A: Homebrew verifies SHA256 checksums automatically. The cask only downloads from official GitHub releases.
