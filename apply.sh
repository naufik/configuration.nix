if [ "$EUID" -ne 0 ]; then
  echo "[err] this requires root privileges"
  exit
fi

rsync --recursive --delete ./nix/ /etc/nixos
echo "[ack] config applied to /etc/nixos in local machine"
