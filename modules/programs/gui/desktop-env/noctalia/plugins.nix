{
  flake.modules.homeManager.noctalia =
    {
      usingTailscale ? false,
      lib,
      ...
    }:
    {
      programs.noctalia-shell.plugins =
        let
          enabledPlugin = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        in
        {
          sources = [
            {
              enabled = true;
              name = "Official Noctalia Plugins";
              url = "https://github.com/noctalia-dev/noctalia-plugins";
            }
          ];

          states = {
            catwalk = enabledPlugin;
            clipper = enabledPlugin;
            pomodoro = enabledPlugin;
            privacy-indicator = enabledPlugin;

            #TODO fix noctalia tailscale plugin enabling logic
            #tailscale = lib.mkIf usingTailscale enabledPlugin;
          };
        };
    };
}
