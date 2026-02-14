class Hpcissh < Formula
  desc "SSH client for HPCI"
  homepage "https://github.com/hpci-auth/hpcissh-clients"

  # url "https://github.com/hpci-auth/hpcissh-clients.git",
  #     tag: "1.12"
  url "https://github.com/soum-takuya/hpcissh-clients-dev.git",
      revision: "fdd8d3885cee13254fe0ada627eb5655f23f2e02"
  version "1.12-rc1"

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

  def caveats
    <<~EOS
      To append the HPCI SSH_CA public key to a known_hosts file:

      # For System-wide configuration (/etc/ssh/ssh_known_hosts)
      hpcissh-append-ssh-ca --system --update

      # For ~/.ssh/known_hosts per user
      hpcissh-append-ssh-ca --user --update

      To enable oidc-agent configurations, please create the directory and link the config files:

      (Please install oidc-agent in advance)

      # For oidc-agent v5
      ln -sf #{opt_pkgshare}/oidc-agent_hpci-main.conf #{etc}/oidc-agent/issuer.config.d/hpci-main
      ln -sf #{opt_pkgshare}/oidc-agent_hpci-sub.conf  #{etc}/oidc-agent/issuer.config.d/hpci-sub

      # For oidc-agent v4
      cat #{opt_pkgshare}/oidc-agent-v4_hpci-pubclients.config >> #{etc}/oidc-agent/pubclients.config
    EOS
  end

  test do
    assert_path_exists bin/"test-hpcissh"
    assert_predicate bin/"test-hpcissh", :executable?
    system bin/"test-hpcissh"
  end
end
