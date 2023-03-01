{ config, pkgs, lib, ... }:
let
  cfg = config.boot.plymouth-encrypt;
in
with lib;
{
  imports = [];

  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;
      theme = "breeze";

      # Disclaimer: I am not affiliated with Framework Computer Inc.
      logo = "${./logo.png}";
    };

    boot.initrd.systemd.enable = true;
  };

  options = {
    boot.plymouth-encrypt = {
      enable = mkEnableOption "plymouth-encrypt"; 
    };
  };
}
