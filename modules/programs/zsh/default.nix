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
        NEXT_TELEMETRY_DISABLED = "1";
        HOMEBREW_NO_ANALYTICS = "1";
        LIMA_SSH_PORT_FORWARDER = "false"; # enables udp port forwarding in colima
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
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

    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      ## Secrets
      [[ ! -f ~/.secrets ]] || source ~/.secrets

      ## Zoxide
      eval "$(zoxide init zsh --cmd cd)"

      ## FNM (Node Manager)
      eval "$(fnm env)"

      ## The Fuck
      eval $(thefuck --alias)

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

      ## MacTeX
      eval "$(/usr/libexec/path_helper)"

      ## age
      func age-decrypt() {
        age -i $HOME/.config/age/keys.txt -d $1
      }
    '';

    plugins = [
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "wd"
      ];
    };
    shellAliases = {
      vim = "nvim";
      k = "kubectl";
      ksn = "kubectl config set-context --current --namespace";
    };
  };

  home.file.".p10k.zsh".source = ./.p10k.zsh;
  home.file.".node_version".source = ./.node_version;
}
