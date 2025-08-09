{pkgs, ...}:
with pkgs; [
  nerd-fonts.meslo-lg
  nerd-fonts.iosevka
  nerd-fonts.iosevka-term
  nerd-fonts.jetbrains-mono

  neovim
  tmux
  git
  git-lfs
  ripgrep
  fzf
  zoxide
  bat
  btop
  zig

  gh
  wget
  pay-respects
  fnm
  uv

  oha
  iperf3

  platformio
  avrdude
  openocd
  arduino-cli

  rustup
  docker
  docker-compose

  thunderbird

  (proxmark3.override {hardwarePlatformExtras = "BTADDON";})
  chameleon-ultra-cli

  presenterm
  morph

  python313Packages.huggingface-hub
  upscayl
]
