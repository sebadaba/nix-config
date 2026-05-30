{
  flake.modules.nixos.android-studio =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (android-studio.override {
          forceWayland = true;
        })
      ];

      nixpkgs.config.android_sdk.accept_license = true;
    };
}
