{ inputs, ... }:
let
  nixosModules = {
    default = import ./nixos/default.nix { inherit inputs; };
    phenixMigrationBase = import ./nixos/phenix-migration-base.nix;
    homeManagerBridge = import ./nixos/home-manager-bridge.nix { inherit inputs; };
    sopsBridge = import ./nixos/sops-bridge.nix;
    sopsBase = import ./nixos/sops-base.nix { inherit inputs; };
    nixBase = import ./nixos/nix-base.nix;
    usersMatthisk = import ./nixos/users-matthisk.nix;
    localeDeEn = import ./nixos/locale-de-en.nix;
    audioPipewire = import ./nixos/audio-pipewire.nix;
    sudoWheelPasswordless = import ./nixos/sudo-wheel-passwordless.nix;
  };
in
{
  flake = {
    nixosConfigurations = inputs.phenix-hosts.nixosConfigurations;

    inherit nixosModules;
  };
}
