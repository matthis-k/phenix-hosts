{ lib, ... }:
{
  options.phenix.migration.newxos.enable = lib.mkEnableOption "Phenix NewXOS migration groundwork";

  config = { };
}
