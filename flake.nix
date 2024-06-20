{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs";

    home-manager =  {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      rivne = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          home-manager = inputs.home-manager.nixosModules.home-manager;
          nixos-hardware = inputs.nixos-hardware.nixosModules;
          nixpkgs-unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; };
        };
        system = "x86_64-linux";
        modules = [
          ./nix/configuration.nix
        ];
      };

      raspi-minimal = let 
        pkgs-aarch64 = import inputs.nixpkgs { system = "aarch64-linux"; };
      in
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs-aarch64 = pkgs-aarch64;
        };
        modules = [
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            nixpkgs.config.allowUnsupportedSystem = true;
            nixpkgs.hostPlatform.system = "aarch64-linux";
            nixpkgs.buildPlatform.system = "x86_64-linux";
          }
          ./nix/home-raspi
        ];
      };

      default = inputs.self.nixosConfigurations.rivne;
    };
  };
}
