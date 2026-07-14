{ inputs }:
{ config, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.phenix-de.nixosModules.default
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

  newxos.nordvpn.enable = true;

  sops.secrets.nordvpn_token = {
    format = "binary";
    mode = "0400";
    path = "/run/secrets/nordvpn_token";
    sopsFile = ../../secrets/nordvpn_token;
  };

  services.displayManager.autoLogin.user = "matthisk";
  system.stateVersion = "25.11";

  boot.zfs.forceImportRoot = false;

  environment.sessionVariables = {
    PHENIX_HOST = config.networking.hostName;
    NEWXOS_HOST = config.networking.hostName;
  };
}
