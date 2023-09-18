# Extra configuration needed in order to deal with
# KVM monitors and i2c utils.

{ config, lib, pkgs, modulesPath, ...}:
{
  hardware.i2c.enable = true;

  services.autorandr.enable = true;

  environment.systemPackages = with pkgs; [ ddcutil ];
}
