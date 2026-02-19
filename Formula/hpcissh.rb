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
    root_url "https://github.com/soum-takuya/homebrew-tap-hpcidev/releases/download/hpcissh-1.12.0-rc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af5bc4852c49619bba9ad03d623de715c30f882d122f6b68f2a73a9cda147a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81513151e8f22e809d0ad1703617eb62a264039096a1c24b1ffa2d0e13230dcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f970f885a4c79d9a1b878751c1d311da2d01ac62d15db973611caa03defd12b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7439da71950619197cb3284fb78303e1c21329af16073e54725ee3e3b5340b7"
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
