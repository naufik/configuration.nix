{ config, pkgs, ... }:
let
  # bash aliases
  aliases = {
    vim = "nvim";
  };

  spotifydMpris = pkgs.spotifyd.override { withMpris = true; withPulseAudio = true; };
in
  {
  imports = [
    ../sys/boot/plymouth.nix
    ../sys/services.nix
    ../sys/monitor.nix
    ../home/naufik
  ];

  config = {
    networking.wireless.iwd.enable = true; #iwd support
    networking.networkmanager.wifi.backend = "iwd";

    boot.plymouth-encrypt.enable = false;
    system.devices.autoUSB.enable = true;

   # Base programs
    programs.light.enable = true;
    programs.dconf.enable = true;

    # Fingerprint Daemon
    services.fprintd.enable = true;

    #Firmware updater for BIOS.
    services.fwupd.enable = true;
    services.fwupd.extraRemotes = ["lvfs-testing"];
    environment.etc."fwupd/uefi_capsule.conf".source = pkgs.lib.mkForce
      (pkgs.writeText "uefi_capsule.conf" ''
      [uefi_capsule]
      DisableCapsuleUpdateOnDisk=true
      OverrideESPMountPoint=${config.boot.loader.efi.efiSysMountPoint}
    '');

    # Set your time zone.
    time.timeZone = "Australia/Melbourne";

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    environment.systemPackages = with pkgs; [
      # Desktop tools
      acpi actkbd pinentry-curses
      gsettings-desktop-schemas

      # Hardware
      polychromatic

      # Terminal
      zellij

      # Desktop environment
      xmobar albert rofi eww dunst
      flameshot
      xfce.thunar
      libsForQt5.ark

      # Security and Networking 
      age

      # Built in desktop app
      thunderbird firefox alacritty pavucontrol
      neovim feh scrot neovide filezilla
      
      # PDF reader
      evince pdfarranger

      # Multimedia
      vlc spotifydMpris playerctl 

      # More cli
      ripgrep
    ];

    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;

    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [ pkgs.haskellPackages.xmobar ];
    };

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

    # Add gpg agent.
    programs.gnupg = {
      agent.enable = true;
      agent.pinentryFlavor = "curses";
      agent.enableSSHSupport = true;
    };

    # Enable sound.
    # sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;

      # Add ability to emulate other sound APIs
      pulse.enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      socketActivation = true;

      wireplumber.enable = true;
    };

    environment.variables = rec {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_DATA_HOME = "\${HOME}/.local/share";
    };

    services.xserver.displayManager.autoLogin.user = "naufik";
    xdg.autostart.enable = true;

    services.tumbler.enable = true;

    # Fonts (system-level)
    nixpkgs.config.joypixels.acceptLicense = true;
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
  };
}
