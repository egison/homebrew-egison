class Egison < Formula
  VERSION = "3.7.9"
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64.tar.gz"
  sha256 "d39a5e656e2b3f62c5e331cb9457965c6b3116afd1db8abca889b7b5f6cdc821"

  def install
    bin.install "bin/egison"
    # bin.install "bin/egison-tutorial"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
