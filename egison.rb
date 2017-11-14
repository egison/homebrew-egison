class Egison < Formula
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/egison.git", :revision => "3.7.0"
  version "3.7.0"
  head "https://github.com/egison/egison.git", :branch => "master"
  # depends_on "cabal-install"

  def install
    system "cabal", "update"
    system "cabal", "install", "--only-dependencies"
    system "cabal", "configure", "--datadir=/usr/local/lib", "--datasubdir=egison"
    system "cabal", "build"
    bin.install "dist/build/egison/egison"
    system "mv", "lib", "egison"
    lib.install "egison"
  end

  test do
    system "egison", "--version"
  end
end
