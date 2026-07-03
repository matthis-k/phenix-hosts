{ inputs }:
{ lib, config, ... }:
let
  cfg = config.phenix.migration.newxos.homeManager;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.phenix.migration.newxos.homeManager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable the disabled-by-default Home Manager migration bridge surface.

      This bridge only enables shared Home Manager package settings. Concrete
      users remain host-owned.
    '';
  };

  config = lib.mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
