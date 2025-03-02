{pkgs, ...}:
with pkgs;
  [
    (nerdfonts.override {
      fonts = [
        "Meslo"
        "Iosevka"
        "IosevkaTerm"
        "JetBrainsMono"
      ];
    })
    neovim
    tmux
    git
    git-lfs
    ripgrep
    fzf
    zoxide
    bat
    delta
    btop

    gh
    wget
    thefuck
    fnm
    uv

    oha
    iperf3
    
    platformio
    avrdude
    openocd
    arduino-cli

    zig
    rustup
    docker
    docker-compose
  ]

