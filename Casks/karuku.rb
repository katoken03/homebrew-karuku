cask "karuku" do
  arch arm: "arm64", intel: "x64"
  
  on_arm do
    version "1.0.0"
    sha256 "cb67dace22db3feee9855d2e5d46698ca39af02e0b8879e2d4ac70aae2c4337a"
  end
  
  on_intel do
    version "1.0.0" 
    sha256 "b47b444a3899d508595fcd4ae4f0781bf965b4b4b1e45ee6292bcd5751cf4825"
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
