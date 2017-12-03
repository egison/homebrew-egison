class Egison < Formula
  VERSION = "3.7.0"
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64.tar.gz"
  sha256 "11e6a76ca3bec4b6e9a1f2c37fd0bee66e6a01b426f17ca942e7f71ff9b2c9ec"

  def install
    bin.install "bin/egison"
    # bin.install "bin/egison-tutorial"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
