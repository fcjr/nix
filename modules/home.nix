{
  pkgs,
  username,
  homeDirectory,
  stateVersion,
  system,
  ...
}: {
  xdg.enable = true;
  fonts.fontconfig.enable = true;
  home = {
    inherit stateVersion username homeDirectory;

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/git/proxmark3"
      "$HOME/Library/Android/sdk/tools"
      "$HOME/Library/Android/sdk/tools/bin"
      "$HOME/Library/Android/sdk/platform-tools"
      "/opt/homebrew/opt/libpq/bin"
      "$HOME/.krew/bin"
    ];

    packages = import ./packages.nix {inherit pkgs;};

    file = {
      ".hushlogin".text = "";
      ".config/ghostty/config".source = ./ghostty/config;
      ".gitconfig".source = ./shell/.gitconfig;
      ".work.gitconfig".source = ./shell/.work.gitconfig;
      ".tmux.conf".source = ./shell/.tmux.conf;
      ".config/btop/btop.conf".source = ./shell/btop.conf;
      ".config/nvim".source = ./nvim;
      ".config/skhd".source = ./skhd;
      ".config/yabai".source = ./yabai;
      ".local/bin".source = ./bin;
      "Library/Application Support/Code/User/settings.json".source = ./vscode/settings.json;
      ".config/zed/settings.json".source = ./zed/settings.json;
    };
  };

imports = [
    ./programs/k9s
    ./programs/zsh
  ];
}
