{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  imports = [
    ../sys/boot/plymouth.nix
    ../sys/services.nix
    ../sys/monitor.nix
    ../home/naufik
  ];

  config = {
    networking.wireless.iwd.enable = true;
    networking.networkmanager.wifi.backend = "iwd";

    boot.plymouth-encrypt.enable = false;
    system.devices.autoUSB.enable = true;

    # Base programs
    programs.dconf.enable = true;

    # Fingerprint Daemon
    services.fprintd.enable = true;

    #Firmware updater for BIOS.
    services.fwupd.enable = true;
    services.fwupd.extraRemotes = [ "lvfs-testing" ];
    environment.etc."fwupd/uefi_capsule.conf".source = pkgs.lib.mkForce (
      pkgs.writeText "uefi_capsule.conf" ''
        [uefi_capsule]
        DisableCapsuleUpdateOnDisk=true
        OverrideESPMountPoint=${config.boot.loader.efi.efiSysMountPoint}
      ''
    );

    services.automatic-timezoned.enable = true;

    environment.systemPackages = with pkgs; [
      # Desktop tools
      acpi
      gsettings-desktop-schemas

      # Terminal
      zellij

      # Desktop environment
      xmobar
      rofi
      eww
      dunst
      xfce.thunar
      kdePackages.ark

      # Security and Networking
      age

      # Built in desktop app
      firefox
      alacritty
      pavucontrol
      feh
      scrot
      neovide
      fastfetch

      nixpkgs-unstable.neovim

      # PDF reader
      pdfarranger

      # Multimedia
      vlc
      playerctl

      # More cli
      ripgrep
      lnav
    ];

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [ haskellPackages.xmobar ];
      #config = ../assets/xmonad.hs;
    };

    # TODO run as service <maybe in home manager>
    services.xserver.displayManager = {
      sessionCommands =
        let
          dunstConfig = ../assets/dunstrc;
        in
        ''
          dunst -conf ${dunstConfig}&
        '';
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
      ];
    };

    networking.firewall.enable = false;

    # Add gpg agent.
    programs.gnupg = {
      agent.enable = true;
      agent.pinentryPackage = pkgs.pinentry-curses;
      agent.enableSSHSupport = true;
    };

    # Enable sound
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

    environment.variables = {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_DATA_HOME = "\${HOME}/.local/share";
    };

    services.displayManager.autoLogin.user = "naufik";
    xdg.autostart.enable = true;

    services.tumbler.enable = true;

    # Fonts (system-level)
    nixpkgs.config.joypixels.acceptLicense = true;
    fonts = {
      enableDefaultPackages = true;

      fontconfig = {
        enable = true;
        defaultFonts = {
          emoji = [
            "JoyPixels"
          ];
        };
      };

      fontDir.enable = true;

      packages = with pkgs; [
        #primary collection
        corefonts
        ucs-fonts
        nerd-fonts.inconsolata

        # extra fonts
        commit-mono

        # Emojis
        joypixels
      ];
    };
  };
}
