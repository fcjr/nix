{pkgs, ...}:
with pkgs; [
  nerd-fonts.meslo-lg
  nerd-fonts.iosevka
  nerd-fonts.iosevka-term
  nerd-fonts.jetbrains-mono
  maple-mono.truetype
  # Maple Mono NF (Ligature unhinted)
  maple-mono.NF-unhinted

  neovim
  helix
  tmux
  git
  git-lfs
  mergiraf
  ripgrep
  fzf
  zoxide
  bat
  btop
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

  colmena
  nixos-generators
  ssh-to-age

  jdk25

  aerospace

  magic-wormhole
  croc


  chirp
  # gnuradio
  # hackrf
  # direwolf
]
