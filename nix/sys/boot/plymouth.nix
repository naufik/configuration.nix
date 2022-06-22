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
    };

    boot.initrd.systemd.enable = true;
  };

  options = {
    boot.plymouth-encrypt = {
      enable = mkEnableOption "plymouth-encrypt"; 
    };
  };
}
