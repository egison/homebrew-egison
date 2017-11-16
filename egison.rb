class Egison < Formula
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/egison.git", :tag => "3.7.0"
  head "https://github.com/egison/egison.git", :branch => "master"

  resource "egison_bin" do
    url "https://github.com/egison/homebrew-egison/releases/download/3.7.0-1/egison_darwin_amd64.zip"
    sha256 "11e6a76ca3bec4b6e9a1f2c37fd0bee66e6a01b426f17ca942e7f71ff9b2c9ec"
  end

  def install
    resource("egison_bin").stage do
      bin.install "egison"
    end
    system "mkdir", "egison"
    system "mv", "lib", "./egison/"
    lib.install "egison"
  end

  test do
    system "egison", "--version"
  end
end
