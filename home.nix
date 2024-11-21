{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.packages = [];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}