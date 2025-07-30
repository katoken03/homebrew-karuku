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
  uninstall quit: "com.katoken03.karuku"
  
  # 完全削除時のクリーンアップ
  zap trash: [
    "~/Library/Application Support/Karuku",
    "~/Library/Preferences/com.katoken03.karuku.plist",
    "~/Library/Logs/Karuku",
    "~/Library/Caches/com.katoken03.karuku"
  ]
end
