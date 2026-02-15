class OidcAgentDesktopAT4 < Formula
  desc "Add oidc-prompt for oidc-agent-cli"
  homepage "https://github.com/indigo-dc/oidc-agent"
  # url "https://github.com/indigo-dc/oidc-agent/archive/refs/tags/v5.3.4.tar.gz"
  # sha256 "21d670851df8a726a9a8e620ec4557c3fd9cc490a06a57ddddfc5a9bdc8f9df0"
  url "https://github.com/indigo-dc/oidc-agent.git",
      revision: "24d962b89e77000e7518e78f0ab20e7cfd43004e", tag: "v4.5.2"
  license "MIT"

  bottle do
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/oidc-agent-desktop@4-4.5.2"
    sha256 cellar: :any, arm64_tahoe:   "94c844d7106cd7ac73860f2ecf43121001ad3366bbc1d6caa3573924307ec004"
    sha256 cellar: :any, arm64_sequoia: "8aa8032400da242525ae625e2ea4122fd83d53138f5e2853bcb3bca3036fd5a0"
  end

  depends_on "help2man" => :build
  depends_on "argp-standalone"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on :macos # macOS only
  depends_on "oidc-agent-cli@4"
  depends_on "pkg-config"
  depends_on "qrencode"

  on_macos do
    # /usr/bin/jq is installed in macOS 15 or later
    depends_on "jq" if OS.mac? && MacOS.version < :sequoia
  end

  def install
    system "make", "-j#{ENV.make_jobs}", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    Dir.glob(bin/"*") do |file|
      # ohai file
      next if %w[oidc-prompt].include?(File.basename(file))

      rm file, verbose: true
    end
    Dir.glob(man1/"*") do |file|
      # ohai file
      next if %w[oidc-prompt.1.gz].include?(File.basename(file))

      rm file, verbose: true
    end
    Dir.glob(lib/"*") do |file|
      # ohai file
      rm file, verbose: true
    end
    Dir.glob(prefix/"etc/oidc-agent/*") do |file|
      # ohai file
      rm file, verbose: true
    end
  end

  test do
    assert_predicate bin/"oidc-prompt", :executable?
  end
end
