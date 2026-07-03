{ inputs }:
{
  imports = [
    ./phenix-migration-base.nix
    (import ./home-manager-bridge.nix { inherit inputs; })
    ./sops-bridge.nix
  ];
}
