{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    GOPRIVATE = "*";
    ANDROID_HOME = "$HOME/Library/Android/sdk";
  };
  home.sessionPath = [
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/cmdline-tools/latest/bin"

    "$HOME/go/bin"

    "$HOME/.local/bin"
  ];

  home.file = {
    ".node_version".source = ./shell/.node_version;
    ".p10k.zsh".source = ./shell/.p10k.zsh;
    ".gitconfig".source = ./shell/.gitconfig;
    ".work.gitconfig".source = ./shell/.work.gitconfig;
    ".tmux.conf".source = ./shell/.tmux.conf;
    ".config/nvim".source = ./nvim;
    ".config/skhd".source = ./skhd;
    ".config/wezterm".source = ./wezterm;
    ".config/yabai".source = ./yabai;
    ".local/bin".source = ./bin;
    "Library/Application Support/Code/User/settings.json".source = ./vscode/settings.json;
  };

  programs = {
    zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "wd"
          ];
        };
        shellAliases = {
          vim = "nvim";
          cd = "z";
        };
        initExtra = ''
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

          ## Secrets
          [[ ! -f ~/.secrets ]] || source ~/.secrets

          ## proxmarke
          [[ ! -f ~/git/proxmark3 ]] || export PATH=$PATH:~/git/proxmark3

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

          function colima-start() {
            colima start --mount-type 9p
          }
        '';

        plugins = [
          {
            name = "powerlevel10k";
            file = "powerlevel10k.zsh-theme";
            src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
          }
        ];
    };
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}