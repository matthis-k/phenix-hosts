{ inputs, ... }:
{
  flake = {
    inherit (inputs.phenix-hosts) nixosConfigurations nixosModules homeModules;
  };
}
