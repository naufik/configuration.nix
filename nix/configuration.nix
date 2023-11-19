# Common configurations to apply to all systems built

{ config, pkgs, ... }:
let
  # Use extraImports to specify system-specific configurations
  extraImports = [
      ./desktop
    ];
in
{
  imports =
    [
     ./machines/daily-driver/hardware-configuration.nix
    ] ++ extraImports;

  nix.settings.trusted-users = [ "root" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  # use GRUB and enable EFI for all systems
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    # System
    pciutils usbutils 
    # System: Helpers
    nixos-option

    # Security and Networking 
    openvpn
    neofetch
    tmux htop wget

    # Global dev tools. 
    cachix rnix-lsp git
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
