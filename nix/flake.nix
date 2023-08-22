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
          home-manager = inputs.home-manager;
          nixos-hardware = inputs.nixos-hardware;
          nixpkgs-unstable = inputs.nixpkgs-unstable;
        };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
      default = inputs.self.nixosConfigurations.rivne;
    };
  };
}
