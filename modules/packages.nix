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
  jj
  zig
  go
  golangci-lint

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

  colmena
  nixos-generators
  ssh-to-age

  jdk24

  aerospace

  magic-wormhole
  croc

  chirp
  # gnuradio
  hackrf
  direwolf
]
