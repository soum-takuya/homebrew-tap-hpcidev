# ORIGINAL: https://github.com/indigo-dc/homebrew-oidc-agent/blob/master/Formula/oidc-agent.rb

class OidcAgentCliAT4 < Formula
  desc "Manage OpenID Connect tokens on the command-line (without oidc-prompt)"
  homepage "https://github.com/indigo-dc/oidc-agent"
  # url "https://github.com/indigo-dc/oidc-agent/archive/refs/tags/v5.3.4.tar.gz"
  # sha256 "21d670851df8a726a9a8e620ec4557c3fd9cc490a06a57ddddfc5a9bdc8f9df0"
  url "https://github.com/indigo-dc/oidc-agent.git",
      revision: "24d962b89e77000e7518e78f0ab20e7cfd43004e", tag: "v4.5.2"
  license "MIT"

  bottle do
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/oidc-agent-cli@4-4.5.2"
    sha256 arm64_tahoe:   "e648fc3fc2c611c6262eb9540e5df426017d0bfd9a9530c8a494ae76a1838eee"
    sha256 arm64_sequoia: "f06922fc04bee26ecc507b59704240d44ed4de931f58d86ef86e23c84145a042"
  end

  depends_on "help2man" => :build
  depends_on "argp-standalone"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on :macos # macOS only
  depends_on "pkg-config"
  depends_on "qrencode"

  on_macos do
    # /usr/bin/jq is installed in macOS 15 or later
    depends_on "jq" if OS.mac? && MacOS.version < :sequoia
  end

  def install
    system "make", "-j#{ENV.make_jobs}", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    rm bin/"oidc-prompt"
    rm man1/"oidc-prompt.1"
  end

  service do
    run [opt_bin/"oidc-agent", "-a", "~/Library/Caches/oidc-agent/oidc-agent.sock", "-d"]
    keep_alive true
    working_dir var
    log_path var/"log/oidc-agent.log"
    error_log_path var/"log/oidc-agent.log"
    environment_variables PATH: "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin"
  end

  def caveats
    <<~EOS
      To start oidc-agent as a background service now and restart at login:
        brew services start oidc-agent
      If you don't need a background service, you can run the following instead:
        oidc-agent -a ~/Library/Caches/oidc-agent/oidc-agent.sock -d
    EOS
  end

  test do
    refute_path_exists bin/"oidc-prompt"
    assert_match version.to_s, shell_output("#{bin}/oidc-agent --version")
  end
end
