{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
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
        nh.enable = true;
      };
      home.packages = with pkgs; [
        macchina
      ];
      xdg.configFile = {
        "macchina/themes/custom.toml".text = ''
          hide_ascii = true

          [box]
          title = "khaen"
          border = "rounded"
          visible = true
        '';
      };
    };
}
