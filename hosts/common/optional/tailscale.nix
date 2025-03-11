# Not working
{
  pkgs,
  config,
  ...
}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets."tailscale_auth_key".path;
    authKeyParameters.baseURL = "https://api.tailscale.com";
  };
}
