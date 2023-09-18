if [ "$EUID" -ne 0 ]; then
  echo "[err] this requires root privileges"
  exit
fi

echo "[ack] config applied to /etc/nixos in local machine"

if [ "$1" = "switch" ]; then
  nixos-rebuild switch --show-trace --flake ./nix
  echo "[ack] switched to new config"
elif [ "$1" = "boot" ]; then
  nixos-rebuild boot --show-trace --flake ./nix
  echo "[ack] new config will be activated on next boot"
fi

