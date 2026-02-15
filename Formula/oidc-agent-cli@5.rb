# ORIGINAL: https://github.com/indigo-dc/homebrew-oidc-agent/blob/master/Formula/oidc-agent.rb

class OidcAgentCliAT5 < Formula
  desc "Manage OpenID Connect tokens on the command-line (without oidc-prompt)"
  homepage "https://github.com/indigo-dc/oidc-agent"
  url "https://github.com/indigo-dc/oidc-agent/archive/refs/tags/v5.3.4.tar.gz"
  sha256 "21d670851df8a726a9a8e620ec4557c3fd9cc490a06a57ddddfc5a9bdc8f9df0"
  license "MIT"

  conflicts_with "oidc-agent", because: "conflict"
  conflicts_with "oidc-agent-cli@4", because: "conflict"

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
