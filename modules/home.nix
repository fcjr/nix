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
    sessionPath = ["$HOME/.local/bin"];
    packages = import ./packages.nix {inherit pkgs;};

    file = {
      ".gitconfig".source = ./shell/.gitconfig;
      ".work.gitconfig".source = ./shell/.work.gitconfig;
      ".tmux.conf".source = ./shell/.tmux.conf;
      ".config/nvim".source = ./nvim;
      ".config/skhd".source = ./skhd;
      ".config/wezterm".source = ./wezterm;
      ".config/yabai".source = ./yabai;
      ".local/bin".source = ./bin;
      "Library/Application Support/Code/User/settings.json".source = ./vscode/settings.json;
    };
  };

imports = [
    ./programs/k9s
    ./programs/zsh
  ];
}
