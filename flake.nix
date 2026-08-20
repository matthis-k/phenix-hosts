# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: import ./outputs.nix inputs;

  inputs = {
    den.url = "github:denful/den";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.follows = "phenix-pins/flake-file";
    flake-parts.follows = "phenix-pins/flake-parts";
    home-manager.follows = "phenix-pins/home-manager";
    nixpkgs.follows = "phenix-pins/nixpkgs";
    phenix-conductor = {
      url = "github:matthis-k/phenix-conductor";
      inputs.phenix-pins.follows = "phenix-pins";
    };
    phenix-de = {
      url = "github:matthis-k/phenix-de";
      inputs = {
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        phenix-pins.follows = "phenix-pins";
      };
    };
    phenix-harness = {
      url = "github:matthis-k/phenix-harness";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        phenix-conductor.follows = "phenix-conductor";
      };
    };
    phenix-nvim = {
      url = "github:matthis-k/phenix-nvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        phenix-conductor.follows = "phenix-conductor";
        phenix-harness.follows = "phenix-harness";
        phenix-pins.follows = "phenix-pins";
      };
    };
    phenix-pins.url = "github:matthis-k/phenix-pins";
    sops-nix.follows = "phenix-pins/sops-nix";
  };
}
