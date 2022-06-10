if [ "$EUID" -ne 0 ]; then
  echo "[err] this requires root privileges"
  exit
fi

rsync --recursive --delete ./nix/ /etc/nixos
echo "[ack] config applied to /etc/nixos in local machine"

if [ "$1" = "switch" ]; then
  nixos-rebuild switch
  echo "[ack] switched to new config"
elif [ "$1" = "boot" ]; then
  nixos-rebuild boot
  echo "[ack] new config will be activated on next boot"
fi

