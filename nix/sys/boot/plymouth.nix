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
      logo = pkgs.fetchurl {
        url = "https://naufik.net/stash/framework-logo-white.png";
        sha256 = "1n6y2840cf53kgrcrhjjvr3pzdm0fa52hr8khxss21r6k261j6h9";
      };
    };

    boot.initrd.systemd.enable = true;
  };

  options = {
    boot.plymouth-encrypt = {
      enable = mkEnableOption "plymouth-encrypt"; 
    };
  };
}
