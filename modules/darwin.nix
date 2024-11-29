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
    wezterm
    vscode-with-extensions

    spotify
  ];

  brews' = [
    "mas"
  ];

  casks' = [
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
    "notchnook"
    "logi-options+"

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
    "utm"
  ];
  masApps' = {
    "Bitwarden" = 1352778147;
    "Pure Paste" = 1611378436;
    "AdGuard for Safari" = 1440147259;
    "SponsorBlock for Safari" = 1573461917;
    "Kagi for Safari" = 1622835804;
    "Apple Configurator" = 1037126344;
    "UniFi" = 1057750338;
    "UniFi Protect" = 1392492235;
    "UniFi WiFiman" = 1385561119;
    "Refined GitHub" = 1519867270;
  };
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
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  homebrew = {
    enable = true;
    brews = brews';
    casks = casks';
    masApps = masApps';
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Set Git commit hash for darwin-version.
  system = {
    stateVersion = 5;
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
          "${pkgs.vscode-with-extensions}/Applications/Visual Studio Code.app"
          "/Applications/Xcode.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.wezterm}/Applications/WezTerm.app"
          "/System/Applications/Notes.app"
          "/System/Applications/System Settings.app"
        ];
        show-recents = false;
        persistent-others = [
          "~/Applications"
          "/Users/${username}/Downloads"
        ];
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    activationScripts.applications.text = let
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
