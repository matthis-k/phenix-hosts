{ inputs, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.default
    inputs.den.flakeModule
    ./inputs.nix
    ./den.nix
    ./outputs.nix
    ./development.nix
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
