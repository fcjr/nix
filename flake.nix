{
  description = "darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    personal-overlay.url = "github:fcjr/nix-overlay/main";

    nix-darwin = {
      url = "github:fcjr/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew/main";
    };
  };

  outputs = {
    self,
    flake-utils,
    home-manager,
    nix-darwin,
    nix-homebrew,
    nixpkgs,
    personal-overlay,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (nix-darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      stateVersion = "24.11";

      overlays = [
        personal-overlay.overlays.default
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
              inherit system pkgs username stateVersion self;
              revision = self.rev or self.dirtyRev or null;
            })
          ];
        };

      makeHomemanagerConfiguration = username:
        homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./modules/home.nix {
              inherit username pkgs stateVersion system self;
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
