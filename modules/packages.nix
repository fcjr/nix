{pkgs, ...}:
with pkgs; [
  nerd-fonts.meslo-lg
  nerd-fonts.iosevka
  nerd-fonts.iosevka-term
  nerd-fonts.jetbrains-mono

  neovim
  helix
  tmux
  git
  git-lfs
  ripgrep
  fzf
  zoxide
  bat
  btop
  jujutsu
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

  # thunderbird

  (proxmark3.override {hardwarePlatformExtras = "BTADDON";})
  chameleon-ultra-cli

  presenterm
  morph

  python313Packages.huggingface-hub
  upscayl
  claude-code

  colmena
  nixos-generators
  ssh-to-age

  jdk25

  aerospace

  magic-wormhole
  croc

  yt-dlp

  chirp
  # gnuradio
  # hackrf
  # direwolf
]
