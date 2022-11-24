# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = import <home-manager> {};
  unstablePkgs = import <unstable-pkgs> { config.allowUnfree = true; };

  # overridePkgs
  spotifydMpris = pkgs.spotifyd.override { withMpris = true; withPulseAudio = true; };

  # bash aliases
  aliases = {
    vim = "nvim";
  };

  fixNssElectron = pkg: pkg.override { nss = pkgs.nss_latest; };
in
{
  imports =
    [
      "${<home-manager>}/nixos"
      ./sys/boot/plymouth.nix
      ./sys/services.nix
      ./machines/daily-driver/hardware-configuration.nix
    ];

  nix.trustedUsers = [ "root" "naufik" ];
  nix.settings.experimental-features = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.joypixels.acceptLicense = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "rivne"; # Define your hostname.
  networking.wireless.iwd.enable = true; #iwd support
  networking.networkmanager.wifi.backend = "iwd";

  # Base programs
  programs.light.enable = true;
  programs.dconf.enable = true;

  # Fingerprint Daemon
  services.fprintd.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Add gpg agent.
  programs.gnupg = {
    agent.enable = true;
    agent.pinentryFlavor = "curses";
    agent.enableSSHSupport = true;
  };

  # DHCP for wireless interface
  networking.interfaces.wlan0.useDHCP = true;

  # Users and shells
  programs.zsh = {
    enable = true;
    shellAliases = aliases;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  users.users.naufik = {
    isNormalUser = true;
    extraGroups = ["video" "wheel" "networkmanager"];
    home = "/home/naufik";
    shell = pkgs.zsh;
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    # I genuinely have no clue, enable everything.
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
    socketActivation = true;
  };

  environment.variables = rec {
    # XDG config directories (they're not set for some reason).
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_DATA_HOME = "\${HOME}/.local/share";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [ pkgs.haskellPackages.xmobar ];
  };

  services.xserver.displayManager = {
    sessionCommands = ''
      dunst&
      albert&
    '';
  };

  services.xserver.displayManager.autoLogin.user = "naufik";
  xdg.autostart.enable = true;
  
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
    # System
    pciutils usbutils acpi actkbd pinentry-curses
    gsettings-desktop-schemas

    # System: Helpers
    nixos-option

    # Desktop environment
    # TODO: remove albert after rofi is entirely set up
    xmobar albert rofi eww dunst

    # Security and Networking 
    age openvpn

    # Built in desktop app
    wget thunderbird firefox alacritty git neofetch tmux htop pavucontrol
    neovim feh scrot neovide
    
    # PDF reader
    evince pdfarranger

    # Global dev tools. 
    cachix rnix-lsp sumneko-lua-language-server

    # spotify
    spotifydMpris playerctl
  ];

  # Fonts (system-level)
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [
          "JoyPixels"
        ];
      };
    };

    fontDir.enable = true;

    fonts = with pkgs; [
      nerdfonts

      # Emojis
      joypixels
    ];
  };

  # Section/Services

  # Essentials
  services.acpid.enable = true;
  services.tlp.enable = true;
  services.getty.autologinUser = "naufik";

  # Aesthetics
  services.picom = {
    enable = true;
    shadow = true;
    shadowExclude = [
      "window_type *= 'menu'"
      "class_g = 'firefox' && argb"
      "class_g = 'albert'"
    ];
  };

  # disable the firewall altogether.
  networking.firewall.enable = false;

  # Home Manager config
  home-manager.users.naufik = {
    nixpkgs.config.allowUnfree = true;

    programs.bash.shellAliases = aliases;

    home.pointerCursor = {
      x11.enable = true;
      gtk.enable = true;

      package = pkgs.qogir-icon-theme;
      name = "Qogir-dark";
    };

    gtk = {
      enable = true;
      theme = {
        name = "Qogir-Dark";
        package = pkgs.qogir-theme;
      };
      iconTheme = {
        name = "Qogir-dark";
        package = pkgs.qogir-icon-theme;
      };
    };

    # User-level packages.
    home.packages = with pkgs; [
      # Basic Usability
      flameshot
      vlc
      xfce.thunar
      libsForQt5.ark
      bitwarden

      # communications
      (fixNssElectron discord)
      fluffychat
      tdesktop  # (telegram desktop)

      # productivity
      anytype
      rawtherapee
      gimp
      notion-app-enhanced
      fritzing
      krita

      # coding
      vscodium

      # Entertainment
      spotify
      spotify-tui

      # Games
      crawlTiles
      dwarf-fortress
      openttd

      # Game development
      blender
      godot
    ];
  };

  # Modules down here are all inhouse and coded locally.

  # This was a good run but also there's more harm than good right now.
  boot.plymouth-encrypt.enable = false;
  system.devices.autoUSB.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
