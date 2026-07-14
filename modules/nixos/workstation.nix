{ inputs, inventory }:
{ config, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.phenix-de.nixosModules.default
    (import ./context.nix { inherit inventory; })
    (import ./home-manager.nix { inherit inputs; })
    (import ./sops.nix { inherit inputs; })
    (import ./nix-base.nix { inherit inputs; })
    ./localsend.nix
    ./services/nordvpn.nix
    ./locale-de-en.nix
    ./audio-pipewire.nix
    ./sudo-wheel-passwordless.nix
    ./networking.nix
    ./dev-mode.nix
  ];

  phenix.sops.enable = true;

  phenix.nordvpn.enable = true;

  sops.secrets.nordvpn_token = {
    format = "binary";
    mode = "0400";
    owner = config.phenix.user.name;
    path = "${config.phenix.paths.secrets}/nordvpn_token";
    sopsFile = ../../secrets/nordvpn_token;
  };

  services.displayManager.autoLogin.user = config.phenix.user.name;
  system.stateVersion = config.phenix.versions.nixos;

  boot.zfs.forceImportRoot = false;

  environment.sessionVariables.PHENIX_HOST = config.networking.hostName;
}
