class Egison < Formula
  VERSION = "3.7.9"
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64.tar.gz"
  sha256 "1b7a70c27bc21b2067cde2f340add4bffd7d592bec73cbdb8386530c49614e45"

  def install
    bin.install "bin/egison"
    # bin.install "bin/egison-tutorial"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
