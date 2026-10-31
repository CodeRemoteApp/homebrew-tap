class Coderemote < Formula
  desc "Use your computer from your iPhone: files, git and a terminal over a Dev Tunnel"
  homepage "https://coderemoteapp.github.io/web/"
  url "https://registry.npmjs.org/coderemote/-/coderemote-0.3.8.tgz"
  sha256 "2493e64903339d225b6ceee25fb11c9d41b2612d400444a258a530ee51897021"
  license "AGPL-3.0-or-later"

  depends_on "node"

  def install
    # The install scripts run: node-pty's picks or builds its native module, and coderemote's
    # makes node-pty's spawn-helper executable.
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # node-pty ships prebuilt modules for other systems too; keep this one's.
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.intel? ? "x64" : "arm64"}"
    prebuilds = libexec/"lib/node_modules/coderemote/node_modules/node-pty/prebuilds"
    prebuilds.children.each { |dir| rm_r dir if dir.basename.to_s != platform } if prebuilds.exist?
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/coderemote --version").strip
  end
end
