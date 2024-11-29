{
  description = "fcjrs darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-utils,
    home-manager,
    nix-darwin,
    nixpkgs,
    nixpkgs-unstable,
    nix-vscode-extensions,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (nix-darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      stateVersion = "24.05";

      upkgs = import nixpkgs-unstable{
        inherit system;
      };

      overlays = [
        (final: prev: {
          neovim = upkgs.neovim; # the stable one is way too old for my plugins
          platformio = upkgs.platformio; # https://github.com/NixOS/nixpkgs/issues/356803
          vscode-with-extensions = prev.vscode-with-extensions.override {
            vscodeExtensions = with nix-vscode-extensions.extensions.${system}.vscode-marketplace;
              [
                # Development
                golang.go
                rust-lang.rust-analyzer
                sswg.swift-lang
                msjsdiag.vscode-react-native
                platformio.platformio-ide

                # Git
                eamodio.gitlens

                # AI/Copilot tools
                continue.continue
                saoudrizwan.claude-dev

                # Language support
                ms-vscode.makefile-tools
                vadimcn.vscode-lldb
                bbenoist.nix
                yoavbls.pretty-ts-errors
                quick-lint.quick-lint-js
                tamasfe.even-better-toml

                # Frameworks & Tools
                tauri-apps.tauri-vscode
                hashicorp.terraform
                bradlc.vscode-tailwindcss
                austenc.tailwind-docs

                # Editor enhancements
                catppuccin.catppuccin-vsc-pack
                ms-vscode-remote.vscode-remote-extensionpack
                editorconfig.editorconfig
                bierner.markdown-mermaid
                mikestead.dotenv
                johnpapa.vscode-cloak
              ]
              ++ prev.vscode-utils.extensionsFromVscodeMarketplace [
                {
                  name = "cpptools";
                  publisher = "ms-vscode";
                  version = "1.23.1";
                  sha256 = "dY9NpeuiweGOIJLrQlH95U1W6KvjneeDUveRj/XIV+I=";
                }
              ];
          };
        })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = {allowUnfree = true;};
      };

      makeDarwinConfiguration = username:
        darwinSystem {
          inherit pkgs;
          modules = [
            home-manager.darwinModules.home-manager
            (import ./modules/darwin.nix {
              inherit system pkgs username stateVersion;
              revision = self.rev or self.dirtyRev or null;
            })
          ];
        };

      makeHomemanagerConfiguration = username:
        homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./modules/home.nix {
              inherit username pkgs stateVersion system;
              homeDirectory =
                if pkgs.stdenv.isLinux
                then "/home/${username}"
                else "/Users/${username}";
            })
          ];
        };
    in {
      packages.darwinConfigurations = {
        "fcjr" = makeDarwinConfiguration "fcjr";
      };

      formatter = pkgs.alejandra;

      packages.homeConfigurations = {
        fcjr = makeHomemanagerConfiguration "fcjr";
      };
    });
}
