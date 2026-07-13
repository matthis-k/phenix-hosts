{
  description = "Phenix NixOS host configurations";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    phenix-pins.url = "github:matthis-k/phenix-pins";
    nixpkgs.follows = "phenix-pins/nixpkgs";
    phenix-tend = {
      url = "github:matthis-k/phenix-tend";
      inputs.phenix-pins.follows = "phenix-pins";
    };
    home-manager.follows = "phenix-pins/home-manager";
    sops-nix.follows = "phenix-pins/sops-nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [
        ./modules/outputs.nix
        ./modules/development.nix
      ];
      flake.flakeModules.default = import ./modules/flake-module.nix;
    };
}
