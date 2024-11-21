{ config, pkgs, ... };

{
  home.stateVersion = "24.05";

  home.packages = [];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      golang.go
      eamodio.gitlens
      Continue.continue
      saoudrizwan.claude-dev
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      sswg.swift-lang
      msjsdiag.vscode-react-native
      ms-vscode.cpptools
      platformio.platformio-ide
      Catppuccin.catppuccin-vsc-pack
      ms-vscode-remote.vscode-remote-extensionpack
      editorconfig.editorconfig
      bierner.markdown-mermaid
      bbenoist.nix
      yoavbls.pretty-ts-errors
      quick-lint.quick-lint-js
      mikestead.dotenv
      johnpapa.vscode-cloak
      bradlc.vscode-tailwindcss
      austenc.tailwind-docs
      tamasfe.even-better-toml
      tauri-apps.tauri-vscode
      hashicorp.terraform
      ms-toolsai.jupyter
    ];
};

  programs.home-manager.enable = true;
}