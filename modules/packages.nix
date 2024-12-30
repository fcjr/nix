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

    platformio
    avrdude
    openocd
    arduino-cli

    go
    rustup
    docker
    kubectl
    k9s
  ]
  ++ lib.optionals stdenv.isDarwin [colima]
