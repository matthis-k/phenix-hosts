# phenix-hosts

This flake is currently a placeholder for NixOS host configurations.

The expected `hosts/<name>/configuration.nix` files are not present in this
checkout, so `nixosConfigurations` is intentionally empty. Add and verify real
host files before enabling imports in `modules/standalone.nix`.
