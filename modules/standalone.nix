{ inputs, ... }: let
  inherit (inputs) nixpkgs disko;
in {
  flake.nixosConfigurations = {
    matthisk-laptop-phenix = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        ./hosts/matthisk-laptop-phenix/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };

    matthisk-desktop-phenix = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        ./hosts/matthisk-desktop-phenix/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };

    phenix-live-usb = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/phenix-live-usb/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };
  };
}
