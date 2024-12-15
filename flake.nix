{
  description = "darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew/main";
      inputs.nix-darwin.follows = "nix-darwin";
    };
  };

  outputs = {
    self,
    flake-utils,
    home-manager,
    nix-darwin,
    nix-homebrew,
    nixpkgs,
    nixpkgs-unstable,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (nix-darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      stateVersion = "24.11";

      upkgs = import nixpkgs-unstable{
        inherit system;
      };

      overlays = [
        (final: prev: {
          neovim = upkgs.neovim; # the stable one is way too old for my plugins
          platformio = upkgs.platformio; # https://github.com/NixOS/nixpkgs/issues/356803
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
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = username;
              };
            }
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
