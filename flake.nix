{
  description = "fcjr's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, nix-vscode-extensions }:
  let
    configuration = { pkgs, config, ... }: 
    let
      system = pkgs.stdenv.hostPlatform.system;

      # since this is wrapped in () the only way to refer to it again in the dock setup
      # is to create it hre and then refer to it later
      # other pkgs can be referenced directly
      # doing it like the others would result in vscode being installed twice, one with 
      # the extensions and one without
      vscode = (pkgs.vscode-with-extensions.override {
        vscodeExtensions = 
          with inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;
          [
            golang.go
            eamodio.gitlens
            continue.continue
            saoudrizwan.claude-dev
            rust-lang.rust-analyzer
            vadimcn.vscode-lldb
            sswg.swift-lang
            msjsdiag.vscode-react-native
            platformio.platformio-ide
            catppuccin.catppuccin-vsc-pack
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
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "cpptools";
              publisher = "ms-vscode";
              version = "1.23.1";
              sha256 = "dY9NpeuiweGOIJLrQlH95U1W6KvjneeDUveRj/XIV+I=";
            }
          ];
      });
    in {
      nixpkgs.config.allowUnfree = true;

      users.users.fcjr = {
        name = "fcjr";
        home = "/Users/fcjr";
        shell = pkgs.zsh;
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [           
          mkalias
          neovim
          tmux
          git
          ripgrep
          fzf
          gh
          wget
          thefuck
          fnm
          
          yabai
          skhd

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

          wezterm
          obsidian
          spotify

          vscode
        ];

      services.yabai.enable = false;
      services.skhd.enable = true;

      homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
          "firefox@developer-edition"
          "google-chrome"
          "brave-browser"
          "opera"
          "orion"
          "xcodes"
          "android-studio"
          "tailscale"
          "proton-mail"
          "protonvpn"
          "proton-drive"
          "raycast"
          "hoppscotch"
          "imageoptim"
          "displaylink"
          "jordanbaird-ice"
          "mist"
          "crystalfetch"
          "rocket"
          "ollama"
          "chatgpt"
          "rectangle"
          "unraid-usb-creator-next"

          "kicad"
          "freecad"
          "bambu-studio"
          "prusaslicer"
          "xtool-creative-space"

          "signal"
          "slack"
          "discord"
          "zoom"

          "steam"
        ];
        masApps = {
          "Bitwarden" = 1352778147;
          "Pure Paste" = 1611378436;
          "AdGuard for Safari" = 1440147259;
          "SponsorBlock for Safari" = 1573461917;
          "Kagi for Safari" = 1622835804;
          "UTM Virtual Machines" = 1538878817;
          "Apple Configurator" = 1037126344;
          "UniFi" = 1057750338;
          "UniFi Protect" = 1392492235;
          "UniFi WiFiman" = 1385561119;
          "Refined GitHub" = 1519867270;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      system.defaults = {
        dock.persistent-apps = [
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/Applications/Proton Mail.app"
          "/System/Applications/Messages.app"
          "/Applications/Signal.app"
          "/Applications/Slack.app"
          "${vscode}/Applications/Visual Studio Code.app"
          "/Applications/Xcode.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.wezterm}/Applications/WezTerm.app"
          "/System/Applications/Notes.app"
          "/System/Applications/System Settings.app"
        ];
        dock.show-recents = false;
        dock.persistent-others = [
          "~/Applications"
          "/Users/fcjr/Downloads"
        ];
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleInterfaceStyle= "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = true;

      security.pam.enableSudoTouchIdAuth = true;

      system.defaults.controlcenter.BatteryShowPercentage = true;
      system.defaults.controlcenter.Bluetooth = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Explicitly enable zsh shell support in nix-darwin.
      environment.shells = with pkgs; [ zsh ];
      programs.zsh.enable = true;
      programs.zsh.enableCompletion = true;


      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#default
    darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            user   = "fcjr";
          };
        }
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fcjr = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."default".pkgs;
  };
}
