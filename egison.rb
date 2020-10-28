class Egison < Formula
  VERSION = "4.1.2"
  version VERSION
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64_#{VERSION}.zip"
  sha256 "69f05c74160d70642a314f8f8e67c8ea5815d29c607b4e9b153575413d265a24"

  def install
    bin.install "bin/egison"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
