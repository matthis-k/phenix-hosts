# Phenix hosts architecture

`phenix-hosts` separates topology from feature implementation.

## Flake layer

- **flake-file** is the source of truth for flake inputs in `modules/inputs.nix` and
  generates the static `flake.nix` required by Nix.
- **flake-parts** remains the output composition layer. It owns per-system outputs,
  the development shell, public module re-exports, and the flake module exported to
  the root Phenix superflake.
- **Den** owns the entity graph: concrete hosts, their users, and the routing of a
  user's NixOS and Home Manager contributions.

The three layers have distinct responsibilities. Flake-file does not define host
configuration, Den does not replace ordinary NixOS modules, and flake-parts does not
encode host/user topology.

## Configuration layer

Plain NixOS and Home Manager modules remain the implementation units:

- `modules/nixos/workstation.nix` contains policy shared by every workstation.
- `modules/nixos/hosts/*.nix` contains only machine-specific choices.
- hardware, storage, and boot modules remain explicit and host-specific.
- service modules remain ordinary reusable NixOS modules.
- `modules/home/matthisk.nix` is the user's Home Manager implementation.
- `modules/nixos/users-matthisk.nix` contains host-level user, secret, SSH, and sudo
  policy.

`modules/den.nix` composes those modules without duplicating their implementation.
The `matthisk` aspect routes Home Manager configuration to the user and host-level
user policy to every host on which that user is declared.

## Deliberate non-goals

- Hardware and storage modules are not converted into generic aspects.
- Service options are not hidden behind Den-specific abstractions.
- `import-tree` is not used. The flake-level module set is small and explicit imports
  currently provide a clearer dependency boundary.
