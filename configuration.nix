# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = import <home-manager> {};
  unstablePkgs = import <unstable> { config.allowUnfree = true; }; 
  
  # overridePkgs
  spotifydMpris = unstablePkgs.spotifyd.override { withMpris = true; withPulseAudio = true; };
  fixLinks = pkg: pkg.override { nss = pkgs.nss_latest; };

  # bash aliases
  aliases = {
    vim = "nvim";
  };
in
{
  imports =
    [
      "${<home-manager>}/nixos"
      ./machines/daily-driver/hardware-configuration.nix
    ];
  
  nixpkgs.config.allowUnfree = true;
  
  # Can we change to the non-SVG version of twemoji??
  nixpkgs.config.joypixels.acceptLicense = true;
  nix.trustedUsers = [ "root" "naufik" ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = unstablePkgs.linuxPackages_latest;

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
  };

  # DHCP for wireless interface
  networking.interfaces.wlan0.useDHCP = true;
  
  # Users
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
    # TODO: run as services.
    sessionCommands = ''
      albert&
      dunst&
    '';
  };

  services.xserver.displayManager.autoLogin.user = "naufik";
  xdg.autostart.enable = true;

  environment.systemPackages = with pkgs; [
   # System 
   pciutils acpi actkbd 
   
   # Desktop environment 
   xmobar albert dunst 
   
   # Themes
   qogir-theme qogir-icon-theme
   
   # Built in desktop app
   wget firefox thunderbird alacritty git
   neofetch tmux htop pavucontrol neovim 
   feh
   
   # Dev (global)
   cachix rnix-lsp 

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

  # Essentials:
  services.acpid.enable = true;
  services.tlp.enable = true;
  services.getty.autologinUser = "naufik";
  
  # Aesthetics:
  services.picom = {
    enable = true;
    shadow = true;
    shadowExclude = [
      "window_type *= 'menu'"
      "class_g = 'firefox' && argb"
      "class_g = 'albert'"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  
  # TODO: move from xmonad to this.
  # TODO (again): make this separate only for my laptop. 
  # services.actkbd = {
  #  enable = true;
  #  bindings = [
  #    { keys = [65]; events = [ "key" ]; command = "${pkgs.light}/bin/light -U 10"; }
  #    { keys = [66]; events = [ "key" ]; command = "${pkgs.light}/bin/light -A 10"; }
  #  ];
  #};

  # Home Manager config
  home-manager.users.naufik = {
    nixpkgs.config.allowUnfree = true;

    programs.zsh.shellAliases = aliases;

    programs.bash.shellAliases = aliases;

    gtk = {
      enable = true;
      theme.name = "Qogir-dark";
    };
    
    # User-level packages. 
    home.packages = with pkgs; [
      # Basic Usability
      flameshot
      vlc
      xfce.thunar
      libsForQt5.ark
       
      # communications
      (fixLinks unstablePkgs.discord)
      unstablePkgs.fluffychat

      # productivity
      rawtherapee
      gimp
      unstablePkgs.notion-app-enhanced
      fritzing

      # coding
      vscodium
      
      # Entertainment
      spotify
      spotify-tui

      # Games
      crawlTiles
      # dwarf-fortress - server error can't download
    ];

  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
