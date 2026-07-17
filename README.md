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

`homeModules.devTools` provides a configurable, language-agnostic terminal and
development toolkit under `phenix.devTools`. Its defaults cover Unix text and file
utilities, Git and GitHub, task and build commands, structured data, archives,
repository navigation, synchronization, benchmarking, and codebase statistics.
Language-specific toolchains and linters remain in repository dev shells.

## Development

Repository maintenance is defined in standalone `maintenance.nix` modules. Each
command receives only its declared package dependencies; the project flake remains
independent from devenv.

```console
nix develop
devenv test
devenv tasks run maintenance:check
devenv tasks run maintenance:fix
```
