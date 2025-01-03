{
  system,
  pkgs,
  revision,
  username,
  stateVersion,
  ...
} @ inputs: let

  packages' = with pkgs; [
    mkalias

    obsidian

    spotify
  ];

  taps' = [
    "hashicorp/tap"
  ];

  brews' = [
    "mas"
    "sqlc"
    "readline"
    "qt@5"
    "gd"
    "pkgconfig"
    "coreutils"
    "recode"
    "astyle"
    "cfssl"
    "hashicorp/tap/terraform"
    "libpq"
    "cmake"

    "hackrf"
    "gnuradio"
    "liquid-dsp"
    "libbladerf"
    "uhd"

    "nsis"
    "upx"
  ];

  casks' = [
    "firefox"
    "firefox@developer-edition"
    "tor-browser"
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
    "yaak"
    "imageoptim"
    "displaylink"
    "jordanbaird-ice"
    "mist"
    "crystalfetch"
    "rocket"
    "google-cloud-sdk"
    "ghostty"
    "imhex"
    "github"

    "ollama"
    "chatgpt"
    "jan"

    "rectangle"
    "unraid-usb-creator-next"
    "logi-options+"
    "dbngin"
    "tableplus"
    "visual-studio-code"
    "zed"

    "arduino-ide"
    "qflipper"

    "kicad"
    "freecad"
    "bambu-studio"
    "prusaslicer"
    "xtool-creative-space"
    "wireshark"

    "signal"
    "slack"
    "discord"
    "zulip"
    "halloy"
    "zoom"

    "steam"
    "moonlight"
    "utm"
    "pocket-casts"
  ];
  masApps' = {
    "Bitwarden" = 1352778147;
    "Pure Paste" = 1611378436;
    "AdGuard for Safari" = 1440147259;
    "SponsorBlock for Safari" = 1573461917;
    "Kagi for Safari" = 1622835804;
    "Apple Configurator" = 1037126344;
    "Refined GitHub" = 1519867270;
    "Meshtastic" = 1586432531;
    "Numbers" = 409203825;
    "Windows App" = 1295203466; # Windows Remote Desktop rebrand
    "Yubico Authenticator" = 1497506650;

    # mas cant install made for iOS apps atm
    # see: https://github.com/mas-cli/mas/issues/321
    # "UniFi" = 1057750338;
    # "UniFi Protect" = 1392492235;
    # "UniFi WiFiman" = 1385561119;
  };
  vscode' = [ # vscode extensions installed via brew
    "eamodio.gitlens"
    "continue.continue"
    "saoudrizwan.claude-dev"
    "ms-azuretools.vscode-docker"
    "ms-python.python"
    "golang.go"
    "rust-lang.rust-analyzer"
    "sswg.swift-lang"
    "vadimcn.vscode-lldb"
    "jnoortheen.nix-ide"
    "yoavbls.pretty-ts-errors"
    "quick-lint.quick-lint-js"
    "tamasfe.even-better-toml"
    "mechatroner.rainbow-csv"
    "msjsdiag.vscode-react-native"
    "ms-vscode.makefile-tools"
    "ms-vscode.cpptools"
    "twxs.cmake"
    "ms-vscode.cmake-tools"
    "bradlc.vscode-tailwindcss"
    "austenc.tailwind-docs"
    "tauri-apps.tauri-vscode"
    "hashicorp.terraform"
    "platformio.platformio-ide"
    "ms-vscode-remote.remote-ssh"
    "catppuccin.catppuccin-vsc-pack"
    "ms-vscode-remote.vscode-remote-extensionpack"
    "editorconfig.editorconfig"
    "bierner.markdown-mermaid"
    "mikestead.dotenv"
    "johnpapa.vscode-cloak"
    "toba.vsfire"
    "svelte.svelte-vscode"
    "expo.vscode-expo-tools"
    "davidanson.vscode-markdownlint"
    "firefox-devtools.vscode-firefox-debug"
  ];
in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = packages';
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };

    # Necessary for using flakes on this system.
    settings = {
      experimental-features = "nix-command flakes auto-allocate-uids";
      trusted-users = [
        "root"
        "${username}"
      ];
    };
  };

  users.users.${username} = {
    home =
      if pkgs.stdenv.isLinux
      then "/home/${username}"
      else "/Users/${username}";
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  homebrew = {
    enable = true;

    global.autoUpdate = false;

    taps = taps';
    brews = brews';
    casks = casks';
    caskArgs = {
      no_quarantine = true;
    };
    masApps = masApps';
    vscode = vscode';
    onActivation = {
      extraFlags = [
        "--quiet"
      ];
      cleanup = "uninstall";
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    stateVersion = 5;
    # Set Git commit hash for darwin-version.
    configurationRevision = revision;

    defaults = {
      loginwindow.GuestEnabled = false;

      # Keyboard preferences
      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain.InitialKeyRepeat = 25;

      # Finder preferences
      finder.FXPreferredViewStyle = "clmv";
      finder.ShowStatusBar = true;
      finder.ShowPathbar = true;

      NSGlobalDomain.AppleInterfaceStyle = "Dark";

      controlcenter.BatteryShowPercentage = true;
      controlcenter.Bluetooth = true;

      # Dock
      dock = {
        persistent-apps = [
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/Applications/Proton Mail.app"
          "/System/Applications/Messages.app"
          "/Applications/Signal.app"
          "/Applications/Slack.app"
          "/Applications/Hoppscotch.app"
          "/Applications/TablePlus.app"
          # "/Applications/Zed.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Xcode.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/Applications/Ghostty.app"
          "/System/Applications/Notes.app"
          "/System/Applications/System Settings.app"
        ];
        show-recents = false;
        persistent-others = [
          {
            path = "~/Applications";
            displayas = "folder";
          }
          {
            path = "/Users/${username}/Downloads";
            displayas = "folder";
            arrangement = "date-added";
            showas = "fan";
          }
        ];
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    activationScripts = {
      extraUserActivation.text = ''
        # Allow touch id to work while docked to a displaylink hub or while screen sharing.
        # https://github.com/usnistgov/macos_security/blob/e22bb0bc02290c54cb968bc3749942fa37ad752b/rules/supplemental/supplemental_smartcard.yaml#L268
        defaults write com.apple.security.authorization ignoreArd -bool TRUE
      '';

      applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = packages';
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
      };
  };
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./home.nix {
      inherit stateVersion pkgs username system;
      nixvim = inputs.nixvim;
      homeDirectory =
        if pkgs.stdenv.isLinux
        then "/home/${username}"
        else "/Users/${username}";
    };
  };
}
