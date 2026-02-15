class OidcAgentDesktopAT5 < Formula
  desc "Add oidc-prompt for oidc-agent-cli"
  homepage "https://github.com/indigo-dc/oidc-agent"
  url "https://github.com/indigo-dc/oidc-agent/archive/refs/tags/v5.3.4.tar.gz"
  sha256 "21d670851df8a726a9a8e620ec4557c3fd9cc490a06a57ddddfc5a9bdc8f9df0"
  license "MIT"

  bottle do
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/oidc-agent-desktop@5-5.3.4"
    sha256 cellar: :any, arm64_tahoe:   "e1c34b99ab4ae37580488cc208444b264f2b2ba8ad2ebd0ce93b87d06486d7a5"
    sha256 cellar: :any, arm64_sequoia: "400557612a54080d14b6593c01696b2e1cca946a1b44d0d38c1d090d3fa19b3f"
  end

  depends_on "help2man" => :build
  depends_on "argp-standalone"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on :macos # macOS only
  depends_on "oidc-agent-cli@5"
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
      rm_r file, verbose: true
    end
  end

  test do
    assert_predicate bin/"oidc-prompt", :executable?
  end
end
