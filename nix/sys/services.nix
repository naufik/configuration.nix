 { config, lib, pkgs, ... }:
  let 
    cfg = config.system.devices.autoUSB;
  in
{
  options = {
    system.devices.autoUSB.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
    
  config = {
    systemd.user.services.udiskie = mkIf config.enable {
      description = "System for auto mounting USB devices.";

      serviceConfig = {
        Type = "exec";
        Restart = "always";
        RestartSec = "3";
        ExecStart = "${pkgs.udiskie}/bin/udiskie";
      };
    };

    environment.systemPackages = [ pkgs.udiskie ];
   };
}
