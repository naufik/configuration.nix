{ config, pkgs, ... }:
let
  home-manager = import <home-manager> {};
  aliases = {
    vim = "nvim";
  };

  fixNssElectron = pkg: pkg.override { nss = pkgs.nss_latest; };
in
  {
    imports = [
      "${<home-manager>}/nixos"
    ];

    config = {
      services.xserver.displayManager = {
        sessionCommands = ''
          dunst&
          albert&
        '';
      };

      nix.settings.trusted-users = [ "naufik" ];

      users.users.naufik = {
        isNormalUser = true;
        extraGroups = ["video" "wheel" "networkmanager"];
        home = "/home/naufik";
        shell = pkgs.zsh;
      };

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

          gtk4.extraConfig = {
            gtk-hint-font-metrics = 1;
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

          # Entertainment
          psst

          # communications
          (fixNssElectron discord)
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

          # Other devtools
          terraform

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

        home.stateVersion = "22.11";
      };

    };
  }
