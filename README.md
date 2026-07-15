# phenix-hosts

NixOS workstation configurations for the Phenix environment. The flake composes the
concrete laptop and desktop through Den while keeping feature implementation in
ordinary NixOS and Home Manager modules.

## Hosts

- `nixosConfigurations.matthisk-laptop-phenix`
- `nixosConfigurations.matthisk-desktop-phenix`

Stable host and user facts live in `modules/inventory.nix`. Typed NixOS and Home
Manager context modules expose those facts under `phenix.host`, `phenix.user`,
`phenix.paths`, and `phenix.versions`. See [docs/architecture.md](docs/architecture.md)
for the composition boundaries.

## Module surfaces

Primary NixOS modules:

- `nixosModules.workstation`
- `nixosModules.context`
- `nixosModules.laptop`
- `nixosModules.desktop`
- `nixosModules.userMatthisk`
- `nixosModules.nordvpn`
- `nixosModules.llmServer`

Primary Home Manager modules:

- `homeModules.matthisk`
- `homeModules.context`
- `homeModules.matthiskBase`
- `homeModules.matthiskSsh`
- `homeModules.devTools`
- `homeModules.git`

`homeModules.devTools` provides a configurable general-purpose CLI toolkit under
`phenix.devTools`. Its defaults include tools for structured data, search, HTTP,
archives, shell validation, command watching, benchmarking, and task execution.

## Development

Enter the development shell and use the Tend-backed helpers:

```console
nix develop
repo-check
repo-fix
repo-pushgate
```
