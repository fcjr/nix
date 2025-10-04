{
  system,
  pkgs,
  revision,
  username,
  stateVersion,
  self,
  ...
} @ inputs: let
  packages' = with pkgs; [
    mkalias

    obsidian
  ];

  taps' = [
    "hashicorp/tap"
    "xataio/pgroll"
    "ariga/tap"
    "siderolabs/tap"
    "kdash-rs/kdash"
    "k8sgpt-ai/k8sgpt"
    "tillitis/tkey"
    "spinframework/tap"
    "leoafarias/fvm"
    "oven-sh/bun"
    "restatedev/tap"
    "fcjr/fcjr"
    "sst/tap"
    "atopile/tap"
    "fastrepl/hyprnote"
    "charmbracelet/tap"
  ];

  brews' = [
    {
      name = "colima";
      args = ["HEAD"];
      # can be reverted once https://github.com/abiosoft/colima/commit/e65e6c6f57aa97615c9cac2e4d7b5437a3d0e581
      # is released (post 0.8.1).
    }
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
    "opentofu"
    "libpq"
    "postgis"
    "xataio/pgroll/pgroll"
    "ariga/tap/atlas"
    "dbmate"
    "cmake"
    "just"
    "wasmtime"
    "act"
    "restic"
    "awscli"
    "cloudflared"
    "zx"
    "fcjr/fcjr/git-vibe"
    "duckdb"
    "elixir"
    "gleam"
    "rebar3"

    "hackrf"
    "gnuradio"
    "liquid-dsp"
    "libbladerf"
    "uhd"

    "nsis"
    "upx"
    "wails"

    "php"
    "composer"

    "c3c"
    "cocoapods"

    "tesseract"
    "ffmpeg"

    "ansible"
    "kubernetes-cli"
    "kind"
    "krew"
    "helm"
    "kustomize"
    "siderolabs/tap/talosctl"
    "talhelper"
    "istioctl"
    "cilium-cli"
    "argocd"
    "k9s"
    "kdash-rs/kdash/kdash"
    "k8sgpt-ai/k8sgpt/k8sgpt"
    "kubeshark"
    "ko"
    "oras"

    "age"
    "age-plugin-yubikey"
    "age-plugin-se"
    "ykman"
    "sops"

    "tillitis/tkey/tkey-verification"
    "tillitis/tkey/tkey-sign"
    "tillitis/tkey/tkey-random-generator"

    "tkey-ssh-agent"

    "posting"

    "tanka"
    "jsonnet"
    "jsonnet-bundler"

    "pdfcpu"

    "spinframework/tap/spin"

    "kcat"

    "deno"
    "oven-sh/bun/bun"

    "leoafarias/fvm/fvm"

    "livekit"
    "certbot"
    "restatedev/tap/restate-server"
    "restatedev/tap/restate"
    "sst/tap/opencode"
    "codex"
    "charmbracelet/tap/crush"
    "slides"

    # Embedded Rust
    "ninja"
    "dfu-util"
    "arm-none-eabi-gdb"
    "openocd"
    "qemu"

    "atopile/tap/atopile"

    "fastrepl/hyprnote/owhisper"
  ];

  casks' = [
    "firefox"
    "firefox@developer-edition"
    "tor-browser"
    "google-chrome"
    "brave-browser"
    "opera"
    "orion"
    "zen"
    "xcodes-app"
    "android-studio"
    "android-ndk"
    "cursor"
    "tailscale-app"
    "proton-mail"
    "protonvpn"
    "proton-drive"
    "raycast"
    "postman"
    "yaak"
    "bruno"
    "imageoptim"
    "displaylink"
    "jordanbaird-ice"
    "mist"
    "crystalfetch"
    "rocket"
    "gcloud-cli"
    "ghostty"
    "imhex"
    "github"
    "teamviewer"
    "obs"
    "audacity"
    "opal-composer"
    "sf-symbols"
    "spotify"

    "1password"
    "1password-cli"

    "ollama-app"
    "claude"
    "chatgpt"
    "msty"
    "lm-studio"
    "superwhisper"
    "comfyui"

    "proton-mail-bridge"

    "topaz-photo-ai"
    "typefully"
    "warp"

    "unraid-usb-creator-next"
    "balenaetcher"
    "raspberry-pi-imager"
    "dbngin"
    "tableplus"
    "dbeaver-community"
    "visual-studio-code"
    "zed"

    # embedded rust
    "wch-ch34x-usb-serial-driver"
    "serial"

    "gcc-arm-embedded"
    "nordic-nrf-command-line-tools"
    "arduino-ide"
    "qflipper"

    "kicad"
    "freecad"
    "bambu-studio"
    "prusaslicer"
    "affinity-designer"
    "affinity-photo"
    "affinity-publisher"
    "figma"
    "xtool-creative-space"
    "openscad"
    "autodesk-fusion"
    "libreoffice"
    "universal-gcode-platform"

    "wifiman"
    "wireshark-app"
    "packetsender"
    "utm"

    "signal"
    "slack"
    "discord"
    "zulip"
    "halloy"
    "zoom"

    "steam"
    "moonlight"
    "epilogue-playback"

    "iina"
    "pocket-casts"
    # "herd" # PHP env manager by Laravel

    "caffeine"
    "rectangle"
    "lunar"
    "logi-options+"

    "dash"
    "mactex"
    "jupyterlab-app"

    "deskpad"
    "blackhole-2ch"
    "fastrepl/hyprnote/hyprnote"
    "linear-linear"

    "feed-the-beast"

    "ExcalidrawZ"
    "grandperspective"
  ];
  masApps' = {
    "Bitwarden" = 1352778147;
    "Pure Paste" = 1611378436;
    "AdGuard for Safari" = 1440147259;
    "SponsorBlock for Safari" = 1573461917;
    "Kagi for Safari" = 1622835804;
    "Dark Reader for Safari" = 1438243180;
    "Apple Configurator" = 1037126344;
    "Refined GitHub" = 1519867270;
    "Meshtastic" = 1586432531;
    "Numbers" = 409203825;
    "Windows App" = 1295203466; # Windows Remote Desktop rebrand
    "Yubico Authenticator" = 1497506650;
    "Reeder." = 6475002485;
    "Enchanted LLM" = 6474268307;
    "Openterface Mini-KVM" = 6478481082;
    "Apple Developer" = 640199958;
    "Chameleon Ultra GUI" = 6462919364;
    "Amazon Kindle" = 302584613;

    # mas cant install made for iOS apps atm
    # see: https://github.com/mas-cli/mas/issues/321
    # "UniFi" = 1057750338;
    # "UniFi Protect" = 1392492235;
    # "UniFi WiFiman" = 1385561119;
  };
  vscode' = [
    # vscode extensions installed via brew
    "esbenp.prettier-vscode"
    "eamodio.gitlens"
    "continue.continue"
    "saoudrizwan.claude-dev"
    "anthropic.claude-code"
    "ms-azuretools.vscode-containers"
    "ms-azuretools.vscode-docker"
    "ms-python.python"
    "ms-python.debugpy"
    "golang.go"
    "rust-lang.rust-analyzer"
    "llvm-vs-code-extensions.lldb-dap"
    "swiftlang.swift-vscode"
    "fwcd.kotlin"
    "vadimcn.vscode-lldb"
    "jnoortheen.nix-ide"
    "yoavbls.pretty-ts-errors"
    "quick-lint.quick-lint-js"
    "csstools.postcss"
    "tamasfe.even-better-toml"
    "mechatroner.rainbow-csv"
    "msjsdiag.vscode-react-native"
    "ms-vscode.makefile-tools"
    "ms-vscode.cpptools"
    "ms-vscode.cmake-tools"
    "ms-vscode.cpptools-extension-pack"
    "llvm-vs-code-extensions.vscode-clangd"
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
    "inlang.vs-code-extension"
    "expo.vscode-expo-tools"
    "davidanson.vscode-markdownlint"
    "firefox-devtools.vscode-firefox-debug"
    "redocly.openapi-vs-code"
    "chanhx.crabviz"
    "bytecodealliance.wit-idl"
    "ziglang.vscode-zig"
    "redhat.vscode-yaml"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "grafana.vscode-jsonnet"
    "bruno-api-client.bruno"
    "charliermarsh.ruff"
    "nefrob.vscode-just-syntax"
    "ms-toolsai.jupyter"
    "denoland.vscode-deno"
    "1Password.op-vscode"
    "pomdtr.excalidraw-editor"
    "ms-ossdata.vscode-pgsql"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.vscode-jupyter-slideshow"
    "fosshaas.fontsize-shortcuts"
    "marp-team.marp-vscode"
    "atopile.atopile"
  ];
in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = packages';
  nix = {
    enable = true;
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

    linux-builder = {
      enable = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 80 * 1024;
          };
        };
      };
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

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;

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
        mru-spaces = false; # Don't rearrange spaces based on most recent use
        persistent-apps = [
          # "/System/Cryptexes/App/System/Applications/Safari.app"
          "/Applications/Firefox Developer Edition.app"
          "/Applications/Proton Mail.app"
          "/System/Applications/Messages.app"
          "/Applications/Signal.app"
          "/Applications/Slack.app"
          "/Applications/Zulip.app"
          "/Applications/TablePlus.app"
          # "/Applications/Zed.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Xcode.app"
          "/Applications/Ollama.app"
          "/Applications/Claude.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/Applications/Hyprnote.app"
          "/Applications/Ghostty.app"
          # "/System/Applications/Notes.app"
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
      touchid.text = ''
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
    users.${username} = {
      config,
      lib,
      ...
    }:
      import ./home.nix {
        inherit config lib stateVersion pkgs username system self;
        nixvim = inputs.nixvim;
        homeDirectory =
          if pkgs.stdenv.isLinux
          then "/home/${username}"
          else "/Users/${username}";
      };
  };
}
