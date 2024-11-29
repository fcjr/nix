{...}: {
  programs.k9s.enable = true;
  home.file.".config/k9s/config.yaml".source = ./config.yaml;
  home.file.".config/k9s/transparent.yaml".source = ./transparent.yaml;
}