{ config, pkgs, ... }:
let 
  home-manager = import <home-manager> {};

  spotifydMpris = pkgs.spotifyd.override { withMpris = true; withPulseAudio = true; };

  # bash aliases
  aliases = {
    vim = "nvim";
  };
in
  {
  imports = [
    ../sys/boot/plymouth.nix
    ../sys/services.nix
    # TODO: separate this? but to me all the desktops should have a naufik user.
    ../home/naufik
  ];

  config = {
    networking.wireless.iwd.enable = true; #iwd support
    networking.networkmanager.wifi.backend = "iwd";

    # This was a good run but also there's more harm than good right now.
    boot.plymouth-encrypt.enable = false;
    system.devices.autoUSB.enable = true;

   # Base programs
    programs.light.enable = true;
    programs.dconf.enable = true;

    # Fingerprint Daemon
    services.fprintd.enable = true;

    # Set your time zone.
    time.timeZone = "Australia/Melbourne";

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    environment.systemPackages = with pkgs; [
      # Desktop environment
      xmobar albert rofi eww dunst
      flameshot
      xfce.thunar
      libsForQt5.ark

      # Security and Networking 
      age

      # Built in desktop app
      thunderbird firefox alacritty pavucontrol
      neovim feh scrot neovide
      
      # PDF reader
      evince pdfarranger

      # Multimedia
      vlc spotifydMpris playerctl 
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
