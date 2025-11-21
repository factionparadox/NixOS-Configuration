{
  description = "Framework 12 (i5-1334U) GNOME + Home Manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.framework12 = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix

          nixos-hardware.nixosModules.framework-12-13th-gen-intel

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.nixos = import ./home-manager/home.nix;
          }
        ];
      };
    };
}
