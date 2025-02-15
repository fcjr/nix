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
    gh
    wget
    thefuck
    fnm
    uv

    platformio
    avrdude
    openocd
    arduino-cli

    zig
    rustup
    docker
    kubectl
    kustomize
    k9s
  ]

