class Egison < Formula
  VERSION = "3.7.14"
  version VERSION
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64_#{VERSION}.zip"
  sha256 "02bd215c5c443b8351ea2ade828ff20397945e98b37019c54aaca713b4dda43d"

  def install
    bin.install "bin/egison"
    # bin.install "bin/egison-tutorial"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
