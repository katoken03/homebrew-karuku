cask "karuku" do
  version "0.1.0"

  on_arm do
    sha256 "7ecfb266dd6f990547ff65df115fbe094d3e8195d9a1931064833acb1ace9e45"
    url "https://github.com/katoken03/karuku/releases/download/v#{version}/Karuku_#{version}_aarch64.dmg"
  end

  on_intel do
    sha256 "ab7a6fd89d9f01f50502567402c04e57b4556dfa46f7f2758100ebb3ed68630e"
    url "https://github.com/katoken03/karuku/releases/download/v#{version}/Karuku_#{version}_x64.dmg"
  end

  name "Karuku"
  desc "Watch folders and optimize PNGs with pngquant"
  homepage "https://github.com/katoken03/karuku"

  depends_on macos: ">= :catalina"
  depends_on formula: "pngquant"

  app "Karuku.app"
end
