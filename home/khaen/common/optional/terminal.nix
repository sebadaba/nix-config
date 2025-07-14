{
  pkgs,
  config,
  ...
}:
{
  programs = {
    zsh = {
      enable = true;
      initContent = ''
        macchina -t custom -o machine,distribution,processor,memory,desktop-environment,terminal,shell,packages,resolution,kernel,battery,uptime
      '';
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    alacritty = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    xpipe
    macchina
  ];
  xdg.configFile = {
    "macchina/themes/custom.toml".text = ''
      hide_ascii = true

      [box]
      title = "${config.hostSpec.primaryUsername}@${config.hostSpec.hostname}"
      border = "rounded"
      visible = true
    '';
  };
}
