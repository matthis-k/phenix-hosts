{
  description = "Phenix NixOS host configurations";

  inputs = {
    phenix-pins.url = "github:matthis-k/phenix-pins";
    phenix-packages.url = "github:matthis-k/phenix-packages";
    phenix-shell.url = "github:matthis-k/phenix-shell";
    phenix-nvim.url = "github:matthis-k/phenix-nvim";
    nixpkgs.follows = "phenix-pins/nixpkgs";
  };

  outputs = inputs: { };
}
