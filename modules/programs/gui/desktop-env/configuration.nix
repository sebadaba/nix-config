{
  inputs,
  ...
}:
{
  flake.modules.nixos.desktop-env = {
    imports = with inputs.self.modules.nixos; [
      greetd
      niri
      multimedia
    ];
  };
}
