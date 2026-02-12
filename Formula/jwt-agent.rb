class JwtAgent < Formula
  desc "Obtain a JSON Web Token (JWT) from a JWT server"
  homepage "https://github.com/oss-tsukuba/jwt-agent"

  url "https://github.com/oss-tsukuba/jwt-agent.git",
      tag: "1.1.1"

  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    inreplace "jwt-agent" do |s|
      s.gsub! "#!/bin/sh", "#!/bin/bash"
    end

    # workaround for "pandoc: No such file or directory"
    touch ["jwt-agent.1.md", "jwt-agent.1"], mtime: Time.now
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system "#{bin}/jwt-agent", "--version"
  end
end
