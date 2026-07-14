{ inputs }:
{
  imports = [ (import ./workstation.nix { inherit inputs; }) ];
}
