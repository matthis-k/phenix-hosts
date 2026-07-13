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

  homeModules = {
    usersMatthiskBase = import ./home/users-matthisk-base.nix;
    usersMatthiskSsh = import ./home/users-matthisk-ssh.nix;
  };
in
{
  flake = {
    # Concrete host configurations remain intentionally disabled until the
    # migrated hosts are complete and independently evaluable.
    nixosConfigurations = { };

    inherit nixosModules homeModules;
  };
}
