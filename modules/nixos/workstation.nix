{ inputs }:
{ config, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.phenix-de.nixosModules.default
    (import ./home-manager.nix { inherit inputs; })
    (import ./sops.nix { inherit inputs; })
    (import ./nix-base.nix { inherit inputs; })
    (import ./users-matthisk.nix { inherit inputs; })
    (import ./localsend.nix { inherit inputs; })
    ./services/nordvpn.nix
    ./locale-de-en.nix
    ./audio-pipewire.nix
    ./sudo-wheel-passwordless.nix
    ./networking.nix
    ./dev-mode.nix
  ];

  phenix.sops.enable = true;

  boot.zfs.forceImportRoot = false;

  environment.sessionVariables = {
    PHENIX_HOST = config.networking.hostName;
    NEWXOS_HOST = config.networking.hostName;
  };
}
