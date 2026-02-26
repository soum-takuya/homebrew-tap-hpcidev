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
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/hpcissh-1.12.0-rc4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f319eafddccd04bbd408583a7a091dd1f8dfd9a6fdbbf6abb236d17e0544d818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1157c5c7fcba4d026b1d43d9108c4183c9734b9bede544311a6ad9f9ceb5ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "135353e71dd726670d3f01cc9f2ab7e29de0cb66a558629e17a3075165de13df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f001743be41c7e36b0d5b54bd1ebb091018db8425c812ef488fab7c1c679762e"
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
