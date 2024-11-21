{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.packages = [];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    ".zshrc".source = ./shell/.zshrc;
    ".node_version".source = ./shell/.node_version;
    ".p10k.zsh".source = ./shell/.p10k.zsh;
    ".gitconfig".source = ./shell/.gitconfig;
    ".work.gitconfig".source = ./shell/.work.gitconfig;
    ".tmux.conf".source = ./shell/.tmux.conf;
    ".config/nvim".source = ./nvim;
    ".config/skhd".source = ./skhd;
    ".config/wezterm".source = ./wezterm;
    ".config/yabai".source = ./yabai;
  };

  programs.home-manager.enable = true;
}