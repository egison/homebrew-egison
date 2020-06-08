class EgisonTutorial < Formula
  VERSION = "4.0.1"
  version VERSION
  desc "A tutorial program for the Egison programming language"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison-tutorial_darwin_x86_64_#{VERSION}.zip"
  sha256 "b629305ed3ed682314643d711f4253e8db5a00c6315351bf05f769aebaa4b5d0"

  def install
    bin.install "bin/egison-tutorial"
    bin.install "bin/egison-tutorial-impl"
    lib.install "lib/egison-tutorial/"
  end

  test do
    system "#{bin}/egison-tutorial", "--version"
  end
end
