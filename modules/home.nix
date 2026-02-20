{
  config,
  lib,
  pkgs,
  username,
  homeDirectory,
  stateVersion,
  system,
  self,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  xdg.enable = true;
  fonts.fontconfig.enable = true;

  home = {
    inherit stateVersion username homeDirectory;

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.nix-managed-scripts/bin"
      "$HOME/Library/Android/sdk/tools"
      "$HOME/Library/Android/sdk/tools/bin"
      "$HOME/Library/Android/sdk/platform-tools"
      "/opt/homebrew/opt/libpq/bin"
      "$HOME/.krew/bin"
      "$HOME/.radicle/bin"
      "/opt/homebrew/opt/make/libexec/gnubin"
      "${pkgs.jdk25}/bin"
    ];

    packages = import ./packages.nix {inherit pkgs;};

    file = {
      ".hushlogin".text = "";
      ".config/ghostty/".source = ./ghostty;
      ".gitconfig".source = ./shell/.gitconfig;
      ".config/git/attributes".source = ./shell/gitattributes;
      ".work.gitconfig".source = ./shell/.work.gitconfig;
      ".tmux.conf".source = ./shell/.tmux.conf;
      ".config/btop/btop.conf".source = ./shell/btop.conf;
      ".config/nvim".source = ./nvim;
      ".config/skhd".source = ./skhd;
      ".config/yabai".source = ./yabai;
      ".nix-managed-scripts/bin".source = ./bin;
      ".clangd".source = ./shell/.clangd;

      # Out-of-store symlinks (edits take effect without rebuild)
      ".config/zed/settings.json".source = mkOutOfStoreSymlink "${homeDirectory}/nix/modules/zed/settings.json";
      "Library/Application Support/Code/User/settings.json".source = mkOutOfStoreSymlink "${homeDirectory}/nix/modules/vscode/settings.json";
      ".agents/skills".source = mkOutOfStoreSymlink "${homeDirectory}/nix/modules/skills";
      ".claude/skills".source = mkOutOfStoreSymlink "${homeDirectory}/nix/modules/skills";
      ".claude/hooks".source = mkOutOfStoreSymlink "${homeDirectory}/nix/modules/claude/hooks";
      ".claude/settings.json".source = mkOutOfStoreSymlink "${homeDirectory}/nix/modules/claude/settings.json";
    };
  };

  imports = [
    ./programs/k9s
    ./programs/zsh
  ];
}
