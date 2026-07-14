{
  flake-file.inputs = {
    phenix-pins.url = "github:matthis-k/phenix-pins";

    flake-file.follows = "phenix-pins/flake-file";
    flake-parts.follows = "phenix-pins/flake-parts";
    nixpkgs.follows = "phenix-pins/nixpkgs";
    home-manager.follows = "phenix-pins/home-manager";
    sops-nix.follows = "phenix-pins/sops-nix";

    den.url = "github:denful/den";

    phenix-tend = {
      url = "github:matthis-k/phenix-tend";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        flake-parts.follows = "flake-parts";
      };
    };

    phenix-de = {
      url = "github:matthis-k/phenix-de";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        phenix-tend.follows = "phenix-tend";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    phenix-nvim = {
      url = "github:matthis-k/phenix-nvim";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        phenix-tend.follows = "phenix-tend";
        flake-parts.follows = "flake-parts";
      };
    };

    phenix-agent-harness = {
      url = "github:matthis-k/phenix-agent-harness";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        phenix-tend.follows = "phenix-tend";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
