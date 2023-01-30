# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # DHCP for wireless interface
  networking.interfaces.wlan0.useDHCP = true;
  networking.hostName = "rivne"; # Define your hostname.

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ab0b19e7-331c-46b6-8a2b-d5e44dcafee7";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."tabula".device = "/dev/disk/by-uuid/443e5974-e13e-481c-8f72-499400ab5beb";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2305-1CF9";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/23e35985-5daa-4d1e-9681-b7bb0b9ac803"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
