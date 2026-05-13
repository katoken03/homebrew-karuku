# ローカル検証専用。本リポジトリと並列に clone した karuku の Apple Silicon 向けリリース DMG を指す。
# 別の場所に置いている場合は `url` を編集する。Intel は x64 DMG と sha256 に差し替える。
cask "karuku-verify-local" do
  version "0.1.0"
  sha256 "7ecfb266dd6f990547ff65df115fbe094d3e8195d9a1931064833acb1ace9e45"

  url "file:///Users/kato/mcp_folder/KarukuProject/karuku/src-tauri/target/release/bundle/dmg/Karuku_#{version}_aarch64.dmg"

  name "Karuku (verify)"
  desc "Local brew install verification for Karuku cask"
  homepage "https://github.com/katoken03/karuku"

  depends_on macos: ">= :catalina"
  depends_on formula: "pngquant"

  app "Karuku.app"
end
