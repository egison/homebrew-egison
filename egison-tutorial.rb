class EgisonTutorial < Formula
  VERSION = "4.0.0"
  version VERSION
  desc "A tutorial program for the Egison programming language"
  homepage "https://www.egison.org/"
  url "https://github.com/egison/homebrew-egison/releases/download/#{VERSION}/egison-tutorial_darwin_x86_64_#{VERSION}.zip"
  sha256 "75729abdbdb396fef5299635344574636d881400b04582e3e6784b31b647b369"

  def install
    bin.install "bin/egison-tutorial"
    bin.install "bin/egison-tutorial-impl"
    lib.install "lib/egison-tutorial/"
  end

  test do
    system "#{bin}/egison-tutorial", "--version"
  end
end
