class Hpcissh < Formula
  desc "SSH client for HPCI"
  homepage "https://github.com/hpci-auth/hpcissh-clients"

  # url "https://github.com/hpci-auth/hpcissh-clients.git",
  #     tag: "v1.12.0"
  url "https://github.com/soum-takuya/hpcissh-clients-dev.git",
      revision: "75119d445353640db1a462215c73e3f107c9c593"
  version "1.12.0-rc5"

  license "Apache-2.0"

  # head "https://github.com/hcpi-auth/hpcissh-clients.git", branch: "main"
  head "https://github.com/soum-takuya/hpcissh-clients-dev.git", branch: "develop"

  bottle do
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/hpcissh-1.12.0-rc5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb482f26de21016e7bc38a8ea15a4323409a715aa705325c90f2c25b2f1549f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba8c11e94e1c3eb2fb33f03f792b49788de6b070517638cffdfc789b6acb7b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efd1b5c0f0a3be438ac61fd02b260315d08bddf364aaa0c39a9dd15150fa1f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5495ab6f820557890843333c8ee77b80756fc09f2b80e21055f1176dc84a03e0"
  end

  depends_on "jwt-agent"

  on_macos do
    # (optional) depends_on "oidc-agent"

    depends_on "bash"
    # /usr/bin/jq is installed in macOS 15 or later
    depends_on "jq" if OS.mac? && MacOS.version < :sequoia
    depends_on "sshpass"

    # curl is required but is already included with macOS
  end

  def install
    args = %W[
      prefix=#{prefix}
    ]
    # use bash version 5 on macOS
    args << "bash_path=#{HOMEBREW_PREFIX}/bin/bash" if OS.mac?
    system "make", *args
    system "make", "install", *args
  end

  # def caveats
  #   <<~EOS
  #   EOS
  # end

  test do
    assert_path_exists bin/"test-hpcissh"
    assert_predicate bin/"test-hpcissh", :executable?
    system bin/"test-hpcissh"
  end
end
