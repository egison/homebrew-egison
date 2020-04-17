class Egison < Formula
  VERSION = "4.0.0"
  version VERSION
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/greymd/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64_#{VERSION}.zip"
  sha256 "89543cb1d78335344110f79c37bd1b9fba4b0098e50f56e415e12840e7624d12"

  def install
    bin.install "bin/egison"
    # bin.install "bin/egison-tutorial"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
