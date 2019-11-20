class EgisonTutorial < Formula
  VERSION = "3.9.3"
  version VERSION
  desc "A tutorial program for the Egison programming language"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison-tutorial_darwin_x86_64_#{VERSION}.zip"
  sha256 "bd77d86665a0e5674f0504ca7719c47b87f560605b569bd4de927e3452f5c428"

  depends_on "egison"

  def install
    bin.install "egison-tutorial"
    bin.install "egison-tutorial-impl"
  end

  test do
    system "#{bin}/egison-tutorial", "--version"
  end
end
