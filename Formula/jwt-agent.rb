class JwtAgent < Formula
  desc "Obtain a JSON Web Token (JWT) from a JWT server"
  homepage "https://github.com/oss-tsukuba/jwt-agent"

  url "https://github.com/oss-tsukuba/jwt-agent.git",
      tag: "1.1.1"

  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system "#{bin}/jwt-agent", "--version"
  end
end
