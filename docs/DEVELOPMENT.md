# Development Guide

## Overview

This guide covers development and maintenance of the Karuku Homebrew Tap. This repository is separate from the main Karuku application and focuses solely on package distribution.

## Repository Structure

```
homebrew-karuku/
├── CLAUDE.md                    # Technical specification
├── README.md                    # User documentation
├── Casks/
│   └── karuku.rb               # Main Cask definition
├── .github/workflows/          # CI/CD automation
│   ├── tests.yml              # Cask validation tests
│   └── update-cask.yml        # Auto-update workflow
├── scripts/                    # Maintenance scripts
│   ├── update-version.sh      # Version update automation
│   ├── calculate-sha256.sh    # SHA256 calculation
│   └── test-install.sh        # Local testing
└── docs/                      # Documentation
    ├── INSTALLATION.md        # Installation guide
    ├── TROUBLESHOOTING.md     # Troubleshooting guide
    └── DEVELOPMENT.md         # This file
```

## Development Workflow

### 1. Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/katoken03/homebrew-karuku.git
cd homebrew-karuku

# Make scripts executable
chmod +x scripts/*.sh

# Install development dependencies
brew install --formula git gh
```

### 2. Local Testing

Before making changes, always test locally:

```bash
# Test cask syntax and style
./scripts/test-install.sh

# Manual testing
brew audit --cask Casks/karuku.rb
brew style Casks/karuku.rb
brew install --cask --dry-run Casks/karuku.rb
```

### 3. Version Updates

When a new Karuku version is released:

#### Manual Update Process

```bash
# Update to new version (e.g., 1.1.0)
./scripts/update-version.sh 1.1.0

# Test the changes
./scripts/test-install.sh

# Commit and push
git add Casks/karuku.rb
git commit -m "Update Karuku to v1.1.0"
git push origin main
```

#### Automated Update Process

The repository includes GitHub Actions for automation:

1. **Trigger automatic update:**
   ```bash
   # Via GitHub UI: Actions > Auto-update Cask > Run workflow
   # Or via API/webhook from main repository
   ```

2. **The workflow will:**
   - Download new release binaries
   - Calculate SHA256 hashes
   - Update the Cask file
   - Create a pull request
   - Run validation tests

### 4. Manual Cask Editing

When editing `Casks/karuku.rb` manually:

#### Key Components to Update

1. **Version numbers:**
   ```ruby
   version "1.1.0"  # Update both ARM64 and Intel blocks
   ```

2. **SHA256 hashes:**
   ```bash
   # Calculate new hashes
   ./scripts/calculate-sha256.sh 1.1.0
   ```

3. **URL pattern (if changed):**
   ```ruby
   url "https://github.com/katoken03/karuku/releases/download/v#{version}/Karuku-#{version}-#{arch}.dmg"
   ```

4. **Dependencies (if macOS requirements change):**
   ```ruby
   depends_on macos: ">= :monterey"  # Update if needed
   ```

#### Validation After Changes

```bash
# Always validate after manual edits
brew audit --cask Casks/karuku.rb
brew style Casks/karuku.rb

# Test installation
brew install --cask ./Casks/karuku.rb --force
brew uninstall --cask karuku
```

## Release Process

### 1. Coordinate with Main Repository

The Homebrew tap release should follow the main Karuku repository:

1. **Main repo releases new version** → Creates GitHub Release with binaries
2. **Homebrew tap updates** → Updates Cask file with new version
3. **Users update** → `brew upgrade --cask karuku`

### 2. Release Checklist

Before releasing a new version:

- [ ] Main Karuku repository has published release with binaries
- [ ] Both ARM64 and Intel DMG files are available
- [ ] SHA256 hashes calculated and verified
- [ ] Cask file updated and tested
- [ ] All CI tests pass
- [ ] Documentation updated if needed

### 3. Emergency Rollback

If a release has issues:

```bash
# Revert to previous version
git revert <commit-hash>
git push origin main

# Or manually edit and re-release
./scripts/update-version.sh 1.0.0  # Previous working version
```

## CI/CD Configuration

### GitHub Actions

#### tests.yml - Continuous Testing

Runs on every push and PR:
- Validates Cask syntax with `brew audit`
- Checks code style with `brew style`
- Performs dry-run installation test

#### update-cask.yml - Automated Updates

Triggered manually or via webhook:
- Downloads new release binaries
- Calculates SHA256 hashes automatically
- Updates Cask file
- Creates pull request for review

### Secrets and Configuration

Required GitHub secrets:
- `GITHUB_TOKEN` - For creating pull requests (automatically provided)

Optional webhook configuration:
- Set up repository dispatch from main Karuku repo
- Automatically trigger updates on new releases

## Maintenance

### Regular Tasks

1. **Monitor main repository releases**
   - Subscribe to release notifications
   - Test new versions promptly

2. **Update documentation**
   - Keep installation guides current
   - Update troubleshooting for common issues

3. **Review and merge automated PRs**
   - Verify automatic updates are correct
   - Test before merging

### Homebrew Best Practices

Follow Homebrew guidelines:

1. **Cask Naming:**
   - Use lowercase, hyphenated names
   - Match the application's common name

2. **Version Management:**
   - Use semantic versioning
   - Keep versions in sync with main app

3. **Architecture Support:**
   - Provide native binaries when possible
   - Use `on_arm`/`on_intel` for architecture-specific builds

4. **Dependencies:**
   - Minimize external dependencies
   - Specify minimum macOS versions accurately

### Code Quality

1. **Ruby Style:**
   ```bash
   # Check style compliance
   brew style Casks/karuku.rb
   ```

2. **Cask Validation:**
   ```bash
   # Comprehensive validation
   brew audit --cask Casks/karuku.rb --strict
   ```

3. **Testing:**
   ```bash
   # Test installation process
   brew install --cask ./Casks/karuku.rb --force
   brew uninstall --cask karuku
   ```

## Contributing

### For External Contributors

1. **Fork the repository**
2. **Create feature branch:** `git checkout -b feature/improvement`
3. **Make changes and test thoroughly**
4. **Submit pull request with detailed description**

### Pull Request Guidelines

- Include detailed description of changes
- Test on both Apple Silicon and Intel if possible
- Update documentation if needed
- Follow existing code style

### Issue Reporting

When reporting issues:
- Use issue templates when available
- Include system information and error messages
- Provide steps to reproduce
- Tag appropriately (bug, enhancement, documentation, etc.)

## Advanced Topics

### Custom Tap Distribution

For private/internal distribution:

```bash
# Create private tap
git clone https://github.com/yourorg/homebrew-internal.git
cd homebrew-internal

# Copy and modify Cask
cp ../homebrew-karuku/Casks/karuku.rb Casks/karuku-internal.rb
# Edit URLs, names, etc.

# Use private tap
brew tap yourorg/internal
brew install --cask karuku-internal
```

### Integration with Main Repository

Set up webhook from main repo to automatically trigger updates:

```javascript
// In main repository's release workflow
- name: Trigger Homebrew Update
  run: |
    curl -X POST \
      -H "Authorization: token ${{ secrets.HOMEBREW_TOKEN }}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/katoken03/homebrew-karuku/dispatches \
      -d '{"event_type":"new-release","client_payload":{"version":"${{ github.event.release.tag_name }}"}}'
```

### Multi-Platform Support

Extend for future Linux support:

```ruby
# In Cask file
on_linux do
  # Linux-specific configuration
end
```

## Resources

- [Homebrew Cask Cookbook](https://docs.brew.sh/Cask-Cookbook)
- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)

## Support

For development questions:
- Create an issue in this repository
- Reference main repository for app-specific questions
- Consult Homebrew documentation for packaging questions
