{ inputs }:
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  hostDevMode = if osConfig == null then false else osConfig.phenix.devMode or false;
  enableRuntimeLuaImport =
    osConfig != null && (osConfig.phenix.de.hyprland.enableRuntimeLuaImport or false);
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
    phenix.devMode = lib.mkDefault hostDevMode;

    home = {
      packages = [
        inputs.phenix-nvim.packages.${system}.nvim-nix
        inputs.phenix-agent-harness.packages.${system}.pi
      ];

      file.".config/hypr/nix-import.lua" = lib.mkIf enableRuntimeLuaImport {
        source = lib.mkForce (
          pkgs.runCommand "phenix-hyprland-nix-import-symlink" { } ''
            ln -s /run/phenix/hypr/nix-import.lua "$out"
          ''
        );
      };

      sessionVariables = {
        PHENIX_ROOT = "${config.home.homeDirectory}/phenix";
        PHENIX_DE_ROOT = "${config.home.homeDirectory}/phenix/repos/phenix-de";
        NEWXOS_FLAKE = "${config.home.homeDirectory}/newxos";
      }
      // lib.optionalAttrs config.phenix.devMode {
        PHENIX_DEV = "1";
        NEWXOS_DEV = "1";
      };
    };
  };
}
