cask "karuku" do
  arch arm: "arm64", intel: "x64"
  
  on_arm do
    version "1.0.1"
    sha256 "d2c4ddb112c111bb661ba9b4d9a93af0b31554cbb9567007f126ac68a3369f99"
  end
  
  on_intel do
    version "1.0.1" 
    sha256 "4d7034976baed09eeea845e3533f15c0c1772ad81dea8d751fec5d4fbe0f52c9"
  end
  
  url "https://github.com/katoken03/karuku/releases/download/v#{version}/Karuku-#{version}-#{arch}.dmg"
  
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
