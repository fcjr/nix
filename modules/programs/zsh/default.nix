{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    sessionVariables =
      {
        TERM = "xterm-256color";
        EDITOR = "nvim";
        ANDROID_HOME = "$HOME/Library/Android/sdk";
        ANDROID_NDK_HOME = "/opt/homebrew/share/android-ndk";
        NDK_HOME = "$ANDROID_NDK_HOME";
        NEXT_TELEMETRY_DISABLED = "1";
        HOMEBREW_NO_ANALYTICS = "1";
        LIMA_SSH_PORT_FORWARDER = "false"; # enables udp port forwarding in colima
        JAVA_HOME = "${pkgs.jdk25}";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        DOCKER_HOST = "unix://$HOME/.config/colima/default/docker.sock";
      };

    localVariables = {
      TERM = "xterm-256color";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };

    historySubstringSearch = {enable = true;};

    initContent = ''

      ## Secrets
      [[ ! -f ~/.secrets ]] || source ~/.secrets

      ## Zoxide
      eval "$(zoxide init zsh --cmd cd)"

      ## FNM (Node Manager)
      eval "$(fnm env)"

      ## Pay Respects
      eval "$(pay-respects zsh --alias)"

      ## Auto FNM
      autoload -U add-zsh-hook
      # place default node version under $HOME/.node_version
      load-nvmrc() {
      DEFAULT_NODE_VERSION=`cat $HOME/.node_version`
      if [[ -f .nvmrc && -r .nvmrc ]]; then
          fnm use
      #elif [[ `node -v` != $DEFAULT_NODE_VERSION ]]; then
      #  echo Reverting to node from "`node -v`" to "$DEFAULT_NODE_VERSION"
      #  fnm use $DEFAULT_NODE_VERSION
      fi
      }
      add-zsh-hook chpwd load-nvmrc
      load-nvmrc

      ## Fix uv run autocomplete to complete files not flags
      _uv_run() {
        if [[ $CURRENT -gt 2 && ''${words[2]} == "run" ]]; then
          _files
        else
          _uv
        fi
      }
      compdef _uv_run uv

      ## MacTeX
      eval "$(/usr/libexec/path_helper)"

      ## age
      func age-decrypt() {
        age -i $HOME/.config/age/keys.txt -d $1
      }

      ## esp-rs
      [[ ! -f ~/export-esp.sh ]] || source $HOME/export-esp.sh


      ## nix wrappper for zsh
      nix() {
        if [[ $1 == "develop" ]]; then
          shift
          command nix develop -c $SHELL "$@"
        else
          command nix "$@"
        fi
      }

      # update all ollama models
      func ollama-update-all() {
        ollama list | awk 'NR>1 {print $1}' | xargs -I {} sh -c 'echo "Updating model: {}"; ollama pull {}; echo "--"' && echo "All models updated."
      }

      ## ensure homebrew takes precedence
      export PATH="/opt/homebrew/bin:$PATH"

      ## RUBY!
      eval "$(rbenv init - --no-rehash zsh)"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    shellAliases = {
      cat = "bat";
      vim = "nvim";
      top = "btop";
      k = "kubectl";
      ksn = "kubectl config set-context --current --namespace";
      nix-shell = "nix-shell --command zsh";
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./oh-my-posh.json));
  };

  home.file.".node_version".source = ./.node_version;
}
