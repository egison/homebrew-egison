class EgisonTutorial < Formula
  VERSION = "4.0.0"
  version VERSION
  desc "A tutorial program for the Egison programming language"
  homepage "https://www.egison.org/"
  url "https://github.com/greymd/homebrew-egison/releases/download/#{VERSION}/egison-tutorial_darwin_x86_64_#{VERSION}.zip"
  sha256 "36bcbb0e548f64cbe8b79b3b8b0c963ea424edc5630841691ffaa6f45bec4655"

  def install
    bin.install "bin/egison-tutorial"
    bin.install "bin/egison-tutorial-impl"
    lib.install "lib/egison-tutorial/"
  end

  test do
    system "#{bin}/egison-tutorial", "--version"
  end
end
