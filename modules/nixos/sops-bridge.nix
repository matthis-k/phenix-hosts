{ lib, config, ... }:
let
  cfg = config.phenix.migration.newxos.secrets;
in
{
  options.phenix.migration.newxos.secrets.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable the disabled-by-default sops-nix migration bridge surface.

      This first slice intentionally does not import sops-nix modules, activate
      secrets, or require credentials.
    '';
  };

  config = lib.mkIf cfg.enable { };
}
