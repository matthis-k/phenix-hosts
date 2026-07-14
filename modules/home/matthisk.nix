{ inputs }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./users-matthisk-base.nix
    ./users-matthisk-ssh.nix
    ./git.nix
    inputs.phenix-de.homeModules.default
  ];

  options.phenix.devMode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Use live Phenix desktop configuration sources.";
  };

  config = {
    home.packages = [
      inputs.phenix-nvim.packages.${system}.nvim-nix
      inputs.phenix-agent-harness.packages.${system}.pi
    ];

    home.sessionVariables = {
      PHENIX_ROOT = "${config.home.homeDirectory}/phenix";
      PHENIX_DE_ROOT = "${config.home.homeDirectory}/phenix/repos/phenix-de";
      NEWXOS_FLAKE = "${config.home.homeDirectory}/newxos";
    }
    // lib.optionalAttrs config.phenix.devMode {
      PHENIX_DEV = "1";
      NEWXOS_DEV = "1";
    };
  };
}
