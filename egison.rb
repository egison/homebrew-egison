class Egison < Formula
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/egison.git", :revision => "3.7.0"
  version "3.7.0"
  head "https://github.com/egison/egison.git", :branch => "master"

  resource "egison_bin" do
    url "https://github.com/egison/homebrew-egison/archive/v1.0.tar.gz"
  end

  def install
    resource("egison_bin").stage do
      bin.install "bin/egison"
    end
    system "mkdir", "egison"
    system "mv", "lib", "./egison/"
    lib.install "egison"
  end

  test do
    system "egison", "--version"
  end
end
