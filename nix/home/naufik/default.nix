{ config, pkgs, home-manager, ... }:
let
  aliases = {
    vim = "nvim";
  };

  fixNssElectron = pkg: pkg.override { nss = pkgs.nss_latest; };
in
  {
    imports = [
      home-manager.nixosModules.home-manager
    ];

    config = {
      services.xserver.displayManager = {
        sessionCommands = ''
          dunst&
          albert&
        '';
      };

      nix.settings.trusted-users = [ "naufik" ];

      # leave here for now
      virtualisation.docker.enable = true;

      users.users.naufik = {
        isNormalUser = true;
        extraGroups = ["video" "wheel" "docker" "networkmanager"];
        home = "/home/naufik";
        shell = pkgs.zsh;
      };

      nixpkgs.config.allowUnfree = true;
      programs.bash.shellAliases = aliases;

      home-manager.users.naufik = {
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
          bitwarden

          # Entertainment
          psst

          # communications
          (fixNssElectron discord)
          tdesktop  # (telegram desktop)

          # productivity
          rawtherapee
          gimp
          fritzing
          krita
          obsidian

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
