cask "karuku" do
  version "1.0.0"
  
  on_arm do
    sha256 "実際のSHA256ハッシュをここに入力"
    url "https://github.com/katoken03/karuku/releases/download/v#{version}/Karuku-#{version}-arm64.dmg"
  end
  
  on_intel do
    sha256 "実際のSHA256ハッシュをここに入力"
    url "https://github.com/katoken03/karuku/releases/download/v#{version}/Karuku-#{version}-x64.dmg"
  end
  
  name "Karuku"
  desc "Image optimization Electron app with automatic directory monitoring"
  homepage "https://github.com/katoken03/karuku"
  
  depends_on macos: ">= :big_sur"
  
  app "Karuku.app"
  
  uninstall quit: "com.katoken03.karuku"
  
  zap trash: [
    "~/Library/Application Support/Karuku",
    "~/Library/Preferences/com.katoken03.karuku.plist", 
    "~/Library/Logs/Karuku",
    "~/Library/Caches/com.katoken03.karuku"
  ]
end
