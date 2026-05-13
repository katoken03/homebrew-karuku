# karuku-homebrew

[Karuku](https://github.com/katoken03/karuku) を Homebrew Cask からインストールするための [third-party tap](https://docs.brew.sh/Taps) です。Cask は実行時依存の **pngquant** を `depends_on formula` で引きます。

## 使い方

```bash
brew tap katoken03/karuku-homebrew
brew install --cask karuku
```

初回は **pngquant** も一緒に入ります（別途 `brew install pngquant` は不要です）。

以前 `karuku-fastrun` tap を使っていた場合は、不要なら外してから上の tap に切り替えてください。

```bash
brew untap katoken03/karuku-fastrun 2>/dev/null || true
brew tap katoken03/karuku-homebrew
```

## Gatekeeper（「壊れているため開けません」）

未署名・未公証のビルドでは macOS が起動を拒否し、このメッセージが出ることがあります。本番配布では Developer ID 署名と公証（notarization）を行うのが正攻法です。開発中のみ試す場合は、Finder で **右クリック → 開く**、または Karuku の README・Tauri ドキュメントに沿った対処を参照してください。

## 新しいバージョンをリリースするとき（メンテ用）

1. `karuku` リポジトリでバージョンを上げ、`npm run tauri:build` と（必要なら）`npm run tauri:build -- --target x86_64-apple-darwin` で DMG を生成する。
2. GitHub Release `vX.Y.Z` を作り、次をアセットとして添付する。
   - Apple Silicon: `Karuku_X.Y.Z_aarch64.dmg`
   - Intel: `Karuku_X.Y.Z_x64.dmg`
3. 各ファイルの SHA256 を計算する（`shasum -a 256 <file>`）。
4. このリポジトリの `Casks/karuku.rb` の `version`・各 `sha256` を更新して push する。

GitHub CLI の例（`katoken03/karuku` への権限が必要）:

```bash
cd /path/to/karuku
gh release create v0.1.0 \
  src-tauri/target/release/bundle/dmg/Karuku_0.1.0_aarch64.dmg \
  src-tauri/target/x86_64-apple-darwin/release/bundle/dmg/Karuku_0.1.0_x64.dmg \
  --repo katoken03/karuku \
  --title "v0.1.0" \
  --notes "Karuku v0.1.0 (Homebrew cask assets)."
```

## ローカル検証用 Cask

**リリース公開前**に Homebrew の依存解決や `/Applications` への配置だけ試す場合、`Casks/karuku-verify-local.rb` の `url` を自分の Mac 上の DMG パスに合わせて編集し:

```bash
brew tap katoken03/karuku-homebrew "$(pwd)"
brew install --cask karuku-verify-local --force   # 既に Karuku.app があるとき
```

`brew audit --cask karuku --online` は GitHub に該当アセットがあるときだけ成功します。

## より短い tap 名にしたい場合

リポジトリ名を `homebrew-karuku` にすると、`brew tap katoken03/karuku` で指せます（Homebrew の慣例）。
