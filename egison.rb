class Egison < Formula
  VERSION = "4.1.3"
  version VERSION
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64_#{VERSION}.zip"
  sha256 "e46b1f0841412f3b66b114476329cd81b49b8419ce518f498744a395841ab330"

  def install
    bin.install "bin/egison"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
