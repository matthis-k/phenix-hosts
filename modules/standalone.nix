{ inputs, ... }: let
  inherit (inputs) nixpkgs disko;
in {
  flake.nixosConfigurations = {
    matthisk-laptop-newxos = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        ./hosts/matthisk-laptop-newxos/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };

    matthisk-desktop-newxos = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        ./hosts/matthisk-desktop-newxos/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };

    newxos-live-usb = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/newxos-live-usb/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };
  };
}
