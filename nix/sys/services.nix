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
    systemd.services.udiskie = lib.mkIf cfg.enable {
      description = "Auto mount usb device";
      wantedBy = [ "multi-user.target" ];
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
