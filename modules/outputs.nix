{ inputs, ... }:
let
  nixosModules = {
    default = import ./nixos/default.nix { inherit inputs; };
    homeManager = import ./nixos/home-manager.nix { inherit inputs; };
    sops = import ./nixos/sops.nix { inherit inputs; };
    nix = import ./nixos/nix-base.nix;
    userMatthisk = import ./nixos/users-matthisk.nix;
    locale = import ./nixos/locale-de-en.nix;
    audio = import ./nixos/audio-pipewire.nix;
    sudo = import ./nixos/sudo-wheel-passwordless.nix;
  };

  homeModules = {
    matthisk = import ./home/users-matthisk-base.nix;
    matthiskSsh = import ./home/users-matthisk-ssh.nix;
  };
in
{
  flake = {
    # Concrete machines remain disabled until their hardware and secret inputs
    # are migrated and independently evaluable.
    nixosConfigurations = { };

    inherit nixosModules homeModules;
  };
}
