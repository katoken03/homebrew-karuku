# Karuku Homebrew Tap 開発仕様書

## プロジェクト概要

KarukuアプリケーションをHomebrew Caskで配布するための専用Tapリポジトリ。メインのKarukuアプリケーションとは分離されたパッケージ管理専用のリポジトリとして設計。

## 技術仕様

### リポジトリ構成
- **リポジトリ名**: homebrew-karuku
- **GitHub URL**: https://github.com/katoken03/homebrew-karuku
- **ローカルパス**: /Users/kato/mcp_folder/homebrew-karuku
- **メインアプリとの関係**: 完全分離（異なるリポジトリ）

### アーキテクチャサポート
- **Apple Silicon (ARM64)**: ネイティブバイナリ
- **Intel (x64)**: ネイティブバイナリ
- **ユニバーサルバイナリ**: 使用しない（方針により除外）

## ディレクトリ構造

```
homebrew-karuku/
├── CLAUDE.md                    # この設計仕様書
├── README.md                    # ユーザー向け説明書
├── Casks/                       # Homebrew Cask定義
│   └── karuku.rb               # メインのCaskファイル
├── .github/                     # GitHub Actions設定
│   └── workflows/
│       ├── tests.yml           # Cask構文テスト
│       └── update-cask.yml     # 自動更新ワークフロー
├── scripts/                     # 管理用スクリプト
│   ├── update-version.sh       # バージョン更新スクリプト
│   ├── calculate-sha256.sh     # SHA256計算スクリプト
│   └── test-install.sh         # ローカルインストールテスト
└── docs/                       # ドキュメント
    ├── INSTALLATION.md         # インストール手順
    ├── TROUBLESHOOTING.md      # トラブルシューティング
    └── DEVELOPMENT.md          # 開発者向けガイド
```

## Cask仕様

### Caskファイル (Casks/karuku.rb)

```ruby
cask "karuku" do
  arch arm: "arm64", intel: "x64"
  
  on_arm do
    version "1.0.0"
    sha256 "ARM64版のSHA256ハッシュ（リリース時に自動取得）"
  end
  
  on_intel do
    version "1.0.0" 
    sha256 "Intel版のSHA256ハッシュ（リリース時に自動取得）"
  end
  
  url "https://github.com/katoken03/karuku/releases/download/v#{version}/Karuku-#{version}-#{arch}.dmg"
  
  name "Karuku"
  desc "Image optimization Electron app with automatic directory monitoring"
  homepage "https://github.com/katoken03/karuku"
  
  # 最小macOSバージョン
  depends_on macos: ">= :big_sur"
  
  app "Karuku.app"
  
  # アンインストール時の処理
  uninstall quit: "com.kato.karuku"
  
  # 完全削除時のクリーンアップ
  zap trash: [
    "~/Library/Application Support/Karuku",
    "~/Library/Preferences/com.kato.karuku.plist",
    "~/Library/Logs/Karuku",
    "~/Library/Caches/com.kato.karuku"
  ]
end
```

### URL命名規則

メインリポジトリのGitHub Releasesから以下の形式でバイナリを取得：

```
ARM64版: Karuku-{version}-arm64.dmg
Intel版: Karuku-{version}-x64.dmg
```

例：
- `Karuku-1.0.0-arm64.dmg`
- `Karuku-1.0.0-x64.dmg`

## 使用方法

### エンドユーザー向け

```bash
# Tapの追加
brew tap katoken03/karuku

# Karukuのインストール
brew install --cask karuku

# 更新
brew upgrade --cask karuku

# アンインストール
brew uninstall --cask karuku

# 完全削除（設定ファイル含む）
brew uninstall --zap --cask karuku
```

### 管理者向け

```bash
# ローカルテスト
brew install --cask ./Casks/karuku.rb

# Tap検証
brew audit --cask karuku

# 構文チェック
brew style Casks/karuku.rb
```

## 開発ワークフロー

### 新バージョンリリース手順

1. **メインリポジトリでのリリース**
   - karukuアプリをビルド（ARM64、Intel別々）
   - GitHub Releasesに両アーキテクチャのDMGをアップロード

2. **Homebrew Tapの更新**
   - 新バージョン番号を確認
   - 各アーキテクチャのSHA256ハッシュを計算
   - `Casks/karuku.rb` のversion、sha256を更新
   - GitHub にpush

3. **検証**
   - ローカルでインストールテスト
   - 複数環境（ARM64、Intel）での動作確認

### 自動化スクリプト

#### scripts/update-version.sh
```bash
#!/bin/bash
# 新バージョンの自動更新スクリプト
# 使用方法: ./scripts/update-version.sh 1.1.0

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

# GitHub Releaseから最新バイナリを取得してSHA256計算
# Caskファイルを自動更新
```

#### scripts/calculate-sha256.sh
```bash
#!/bin/bash
# GitHub Releaseから直接SHA256を計算
# CI/CDでの自動更新に使用
```

## CI/CD設定

### GitHub Actions (.github/workflows/tests.yml)

```yaml
name: Test Casks

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Homebrew
      run: |
        brew update
        brew tap homebrew/cask
    
    - name: Test Cask syntax
      run: |
        brew audit --cask Casks/karuku.rb
        brew style Casks/karuku.rb
    
    - name: Test installation (dry run)
      run: |
        brew install --cask --dry-run Casks/karuku.rb
```

### 自動更新ワークフロー (.github/workflows/update-cask.yml)

```yaml
name: Auto-update Cask

on:
  repository_dispatch:
    types: [new-release]
  workflow_dispatch:
    inputs:
      version:
        description: 'New version number'
        required: true

jobs:
  update:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Update Cask
      run: |
        ./scripts/update-version.sh ${{ github.event.inputs.version }}
    
    - name: Create PR
      uses: peter-evans/create-pull-request@v4
      with:
        title: "Update Karuku to v${{ github.event.inputs.version }}"
        commit-message: "Update Karuku to v${{ github.event.inputs.version }}"
```

## メンテナンス方針

### バージョン管理
- メインアプリのリリースと同期
- セマンティックバージョニング準拠
- 後方互換性の維持

### 品質保証
- 複数環境でのテスト
- SHA256ハッシュの厳格な検証
- Homebrew公式ガイドラインの遵守

### セキュリティ
- GitHub Releasesからの直接ダウンロードのみ
- SHA256による整合性検証
- 署名検証（将来的にコードサイニング対応時）

## 公式化への道筋

### Phase 1: プライベートTap
- 個人/組織のプライベートTapとして運用
- 安定性と利用者数の確立

### Phase 2: コミュニティ貢献
- Homebrew公式ガイドラインへの完全準拠
- ドキュメントの充実
- コミュニティフィードバックの収集

### Phase 3: 公式化申請
- homebrew/homebrew-cask への移行申請
- コミュニティレビューの通過
- 公式Caskとしての採用

## トラブルシューティング

### よくある問題

1. **アーキテクチャ不一致**
   - 症状: 「アプリが起動しない」
   - 解決: 正しいアーキテクチャでの再インストール

2. **SHA256不一致**
   - 症状: インストール時のハッシュエラー
   - 解決: Caskファイルの更新、キャッシュクリア

3. **権限問題**
   - 症状: インストール権限エラー
   - 解決: `sudo`不使用、Homebrewの再インストール

### デバッグ方法

```bash
# Homebrew診断
brew doctor

# Cask固有の問題
brew --cache --cask karuku
brew reinstall --cask karuku --verbose

# ログ確認
tail -f /opt/homebrew/var/log/brew.log
```

## 関連リンク

- [メインKarukuリポジトリ](https://github.com/katoken03/karuku)
- [Homebrew Cask公式ドキュメント](https://docs.brew.sh/Cask-Cookbook)
- [electron-builder設定](https://www.electron.build/)

## 更新履歴

### v1.0.0 (計画)
- 初回リリース
- ARM64、Intel両対応
- 基本的なCask機能の実装

### 今後の計画
- 自動更新機能の実装
- 公式Homebrew Caskへの移行
- より詳細なメタデータの追加
