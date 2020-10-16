class Egison < Formula
  VERSION = "4.1.1"
  version VERSION
  desc "A purely functional programming language with non-linear pattern-matching against non-free data types"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison_darwin_x86_64_#{VERSION}.zip"
  sha256 "762f5ae815121a7574906acc4e871cc890664fcb3b600b957c09de42d8dc543d"

  def install
    bin.install "bin/egison"
    lib.install "lib/egison"
  end

  test do
    system "#{bin}/egison", "--version"
  end
end
