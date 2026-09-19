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

    phenix-ai = {
      url = "github:matthis-k/phenix-ai";
      inputs.phenix-pins.follows = "phenix-pins";
    };

    phenix-ai-nvim = {
      url = "github:matthis-k/phenix-ai.nvim";
      inputs.phenix-ai.follows = "phenix-ai";
    };

    phenix-nvim = {
      url = "github:matthis-k/phenix-nvim";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        flake-parts.follows = "flake-parts";
        phenix-ai-nvim.follows = "phenix-ai-nvim";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
