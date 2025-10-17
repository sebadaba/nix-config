{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "reboot-to-windows" ''
      ENTRY=$(${pkgs.efibootmgr}/bin/efibootmgr | grep -i "windows" | head -1 | sed 's/Boot\([0-9]*\).*/\1/')

      if [ -z "$ENTRY" ]; then
        echo "UEFI Windows boot entry not found!"
        exit 1
      fi

      echo "Rebooting to Windows.. (Boot$ENTRY)..."
      ${pkgs.efibootmgr}/bin/efibootmgr -n 0x$ENTRY && systemctl reboot
    '')
  ];
}
