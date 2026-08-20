{
  flake-file.inputs = {
    phenix-pins.url = "github:matthis-k/phenix-pins";

    flake-file.follows = "phenix-pins/flake-file";
    flake-parts.follows = "phenix-pins/flake-parts";
    nixpkgs.follows = "phenix-pins/nixpkgs";
    home-manager.follows = "phenix-pins/home-manager";
    sops-nix.follows = "phenix-pins/sops-nix";

    den.url = "github:denful/den";

    phenix-de = {
      url = "github:matthis-k/phenix-de";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    phenix-conductor = {
      url = "github:matthis-k/phenix-conductor";
      inputs.phenix-pins.follows = "phenix-pins";
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
        phenix-pins.follows = "phenix-pins";
        flake-parts.follows = "flake-parts";
        phenix-conductor.follows = "phenix-conductor";
        phenix-harness.follows = "phenix-harness";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
