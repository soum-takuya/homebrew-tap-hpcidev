class JwtAgent < Formula
  desc "Obtain a JSON Web Token (JWT) from a JWT server"
  homepage "https://github.com/oss-tsukuba/jwt-agent"

  url "https://github.com/oss-tsukuba/jwt-agent.git",
      tag: "1.1.1"

  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/jwt-agent-1.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c86de0242c2264c8adcfe5ea8d87412846cbfa8fd822df90754bc9d7838b095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328bb2aea4d232b4f64ffe61c8612343f591826754a9b14705b3d008ad34442a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5ae129e06144f92741f34d4bf33e7f4880bfd420a1ca38090b6449917928d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac731493b44abb8bf9fa2918ddfc63f354d9e4c3dac644917713ea29044c0b0"
  end

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
