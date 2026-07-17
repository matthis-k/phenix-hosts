{
  flake-file.inputs = {
    phenix-pins.url = "github:matthis-k/phenix-pins?ref=refactor/standalone-devenv-maintenance";

    flake-file.follows = "phenix-pins/flake-file";
    flake-parts.follows = "phenix-pins/flake-parts";
    nixpkgs.follows = "phenix-pins/nixpkgs";
    home-manager.follows = "phenix-pins/home-manager";
    sops-nix.follows = "phenix-pins/sops-nix";

    den.url = "github:denful/den";

    phenix-de = {
      url = "github:matthis-k/phenix-de?ref=devenv-maintenance";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    phenix-nvim = {
      url = "github:matthis-k/phenix-nvim?ref=refactor/standalone-devenv-maintenance";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        flake-parts.follows = "flake-parts";
      };
    };

    phenix-agent-harness = {
      url = "github:matthis-k/phenix-agent-harness?ref=refactor/standalone-devenv-maintenance";
      inputs.phenix-pins.follows = "phenix-pins";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
