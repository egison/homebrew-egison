class EgisonTutorial < Formula
  VERSION = "4.1.3"
  version VERSION
  desc "A tutorial program for the Egison programming language"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison-tutorial_darwin_x86_64_#{VERSION}.zip"
  sha256 "3d996a8dd86c6e2953f883a014cb46a78925f9e41ce68899beca5331934f8e97"

  def install
    bin.install "bin/egison-tutorial"
    bin.install "bin/egison-tutorial-impl"
    lib.install "lib/egison-tutorial/"
  end

  test do
    system "#{bin}/egison-tutorial", "--version"
  end
end
