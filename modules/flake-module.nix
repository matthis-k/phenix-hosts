{ inputs, ... }: {
  flake.nixosConfigurations = inputs.phenix-hosts.nixosConfigurations;
}
