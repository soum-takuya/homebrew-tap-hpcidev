class Hpcissh < Formula
  desc "SSH client for HPCI"
  homepage "https://github.com/hpci-auth/hpcissh-clients"

  # url "https://github.com/hpci-auth/hpcissh-clients.git",
  #     tag: "v1.12.0"
  url "https://github.com/soum-takuya/hpcissh-clients-dev.git",
      revision: "4e3b25e8ae34e837dec2bce0b2e39be98a3320c1"
  version "1.12.0-rc4"

  license "Apache-2.0"

  # head "https://github.com/hcpi-auth/hpcissh-clients.git", branch: "main"
  head "https://github.com/soum-takuya/hpcissh-clients-dev.git", branch: "develop"

  bottle do
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/hpcissh-1.12.0-rc3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e585e6858e629a6b4b7f4f4c2549fc16f5723f0791d05b4dcee060e55acb3e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b042659fa512baaaf1ad6e0cc7b88b19569af414e239737991366d53ef732624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9de2daf0f6e68cdb5c48c551b57b4fda6c357e0318b8f048f7dfff8c3a336c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ee78070bff87da49df5e0e968113457924c8881bcf11ad00f442c7d474eef4e"
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
