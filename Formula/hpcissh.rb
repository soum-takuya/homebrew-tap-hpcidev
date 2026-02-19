class Hpcissh < Formula
  desc "SSH client for HPCI"
  homepage "https://github.com/hpci-auth/hpcissh-clients"

  # url "https://github.com/hpci-auth/hpcissh-clients.git",
  #     tag: "v1.12.0"
  url "https://github.com/soum-takuya/hpcissh-clients-dev.git",
      revision: "bbe3962c5cf2d340575c3bfd8ab2c734cba00c0a"
  version "1.12.0-rc2"

  license "Apache-2.0"

  # head "https://github.com/hcpi-auth/hpcissh-clients.git", branch: "main"
  head "https://github.com/soum-takuya/hpcissh-clients-dev.git", branch: "rc-1.12"

  bottle do
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/hpcissh-1.12-rc1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4c8e6ee04a6506232b41319b2985b86ec9b339104a21381fb3855c27d0bc1eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "232c3e110c300baac0c0cbdb6dae00a60a74d0fd19abf100c070512c6f150793"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9026e26c2755de9d067d55777e2c032e4bde2e7d5f42317aab079c992d02787c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2233a000a0cde2bce446a29f96602f7195e74cf501c18ca4e6d1e9484010e232"
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
