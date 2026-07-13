{ inputs }:
{
  imports = [
    (import ./home-manager.nix { inherit inputs; })
    (import ./sops.nix { inherit inputs; })
    ./nix-base.nix
    ./users-matthisk.nix
    ./locale-de-en.nix
    ./audio-pipewire.nix
    ./sudo-wheel-passwordless.nix
  ];
}
