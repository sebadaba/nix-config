{pkgs, ...}: let
  mathematicaPinned =
    pkgs.mathematica.override
    {
      # First, download the installer and then run:
      # $ nix store add-path Mathematica_XX.X.X_LINUX.sh --name 'Mathematica_XX.X.X_LINUX.sh'
      # replace the X's with the version of your installer, of course, and save the printed path for the next step.
      # (In my case, the path looked like "/nix/store/dwr17aivc79drbxbvl37m9mi3j02m6w6-Mathematica_14.0.0_LINUX.sh")

      # Then, get the hash of the file with:
      # $ nix-store --query --hash /the/path/from/before
      # and copy that into the source.sha256 field, and also copy the name of the file in the source.name field.

      source = pkgs.requireFile {
        name = "Mathematica_14.0.0_LINUX.sh";
        sha256 = "sha256:0agw5zzk3yk2s85jgc3x4gd1rfvw2a42fjc6cs5fsi74qw8raqn1";
        message = ''
          Your override for Mathematica includes a different src for the installer,
          and it is missing.
        '';
        hashMode = "recursive";
      };
    };
  initialWindowHyprlandRegex = "initialTitle:(Mathematica), initialClass:(com.wolfram.Mathematica)(.*)";
in {
  home.packages = [mathematicaPinned];
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # rules for the initial window
      "float, ${initialWindowHyprlandRegex}"
      "size 800 700, ${initialWindowHyprlandRegex}"
      "center, ${initialWindowHyprlandRegex}"
    ];
  };
}
