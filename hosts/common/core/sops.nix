# hosts level sops. see home/[user]/common/optional/sops.nix for home/user level
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  #sopsFolder = builtins.toString inputs.nix-secrets + "/sops";
  sopsFolder = builtins.toString inputs.nix-secrets;
in {
  sops = {
    defaultSopsFile = "${sopsFolder}/secrets.yaml";
    validateSopsFiles = false;
    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
    # secrets will be output to /run/secrets
    # e.g. /run/secrets/msmtp-password
    # secrets required for user creation are handled in respective ./users/<username>.nix files
    # because they will be output to /run/secrets-for-users and only when the user is assigned to a host.
    secrets = {
      "users/${config.hostAttr.primaryUsername}/password" = {
        neededForUsers = true;
      };
    };
  };
}
