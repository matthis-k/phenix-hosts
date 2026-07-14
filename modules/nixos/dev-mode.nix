{ lib, ... }:
{
  options.phenix.devMode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether desktop packages should use live repository configuration files.";
  };

  config = {
    environment.sessionVariables = lib.mkIf false { };

    specialisation.dev = {
      inheritParentConfig = true;
      configuration = {
        phenix.devMode = true;
        environment.sessionVariables = {
          PHENIX_DEV = "1";
          NEWXOS_DEV = "1";
        };
      };
    };
  };
}
