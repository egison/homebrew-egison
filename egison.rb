class Egison < Formula
  VERSION = "3.9.0"
  version VERSION
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64_#{VERSION}.zip"
  sha256 "2b5c357fd9352fe807c125e3973989c72f498e55013d00a46f86242b3ed16112"

  def install
    bin.install "bin/egison"
    # bin.install "bin/egison-tutorial"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
