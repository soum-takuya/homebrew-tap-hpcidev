class Hpcissh < Formula
  desc "SSH client for HPCI"
  homepage "https://github.com/hpci-auth/hpcissh-clients"

  # url "https://github.com/hpci-auth/hpcissh-clients.git",
  #     tag: "1.12"
  url "https://github.com/soum-takuya/hpcissh-clients-dev.git",
      revision: "d50655f6102ce8211d4c22f9deeaff8bd570038d"
  version "1.12-rc1"

  license "Apache-2.0"

  # head "https://github.com/hcpi-auth/hpcissh-clients.git", branch: "main"
  head "https://github.com/soum-takuya/hpcissh-clients-dev.git", branch: "rc-1.12"

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
    system "make", "prefix=#{prefix}", "bash_path=#{HOMEBREW_PREFIX}/bin/bash"
    system "make", "install", "prefix=#{prefix}"

    etc_oidcagent_d = (etc/"oidc-agent")
    etc_oidcagent_d.install_symlink pkgshare/"oidc-agent-v4_hpci-pubclients.config" => "pubclients.config"
    issuer_config_d = (etc_oidcagent_d/"issuer.config.d")
    issuer_config_d.mkpath
    issuer_config_d.install_symlink pkgshare/"hpci-main" => "hpci-main"
    issuer_config_d.install_symlink pkgshare/"hpci-sub" => "hpci-sub"
  end

  test do
    system "#{bin}/test-hpcissh"
  end
end
