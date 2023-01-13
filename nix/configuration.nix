# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  # unstablePkgs = import <unstable-pkgs> { config.allowUnfree = true; };

  extraImports = [
      ./home/naufik
      ./desktop
    ];
in
{
  imports =
    [
     ./machines/daily-driver/hardware-configuration.nix
    ] ++ extraImports;

  nix.settings.trusted-users = [ "root" ];
  nix.settings.experimental-features = ["nix-command"];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

# Users and shells
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # System
    pciutils usbutils acpi actkbd pinentry-curses
    gsettings-desktop-schemas

    # System: Helpers
    nixos-option

    # Security and Networking 
    openvpn
    neofetch tmux htop wget

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
