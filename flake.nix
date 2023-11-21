{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs";

    home-manager =  {
      url = "github:nix-community/home-manager/release-23.05";
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
          nixpkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
        };
        system = "x86_64-linux";
        modules = [
          ./nix/configuration.nix
        ];
      };
      default = inputs.self.nixosConfigurations.rivne;
    };
  };
}
