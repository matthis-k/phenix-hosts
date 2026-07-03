# phenix-hosts

This flake is currently a placeholder for NixOS host configurations and reusable
base module surfaces.

The expected `hosts/<name>/configuration.nix` files are not present in this
checkout, so `nixosConfigurations` is intentionally empty. Add and verify real
host files before enabling imports in `modules/standalone.nix`.

## Module surfaces

NixOS modules:

- `nixosModules.sopsBase`
- `nixosModules.sopsBridge`
- `nixosModules.nixBase`
- `nixosModules.homeManagerBridge`
- `nixosModules.usersMatthisk`
- `nixosModules.localeDeEn`
- `nixosModules.audioPipewire`
- `nixosModules.sudoWheelPasswordless`

Home Manager modules:

- `homeModules.usersMatthiskBase`
- `homeModules.usersMatthiskSsh`

Deferred migration work includes host enablement, concrete Home Manager user
imports, GitHub credentials, nix-ld, OpenSSH server enablement, secret payloads,
desktop/dev bundles, hardware, and workflow migration.
