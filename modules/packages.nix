{pkgs, ...}:
with pkgs;
  [
    (nerdfonts.override {
      fonts = ["Meslo"];
    })
    neovim
    tmux
    git
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
    colima
    docker
    kubectl
    k9s
  ]
  ++ lib.optionals stdenv.isDarwin [colima qemu]
