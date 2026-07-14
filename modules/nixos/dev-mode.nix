{ lib, ... }:
{
  options.phenix.devMode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether desktop packages should use live repository configuration files.";
  };

  config.specialisation.dev = {
    inheritParentConfig = true;
    configuration = {
      phenix.devMode = true;
      environment.sessionVariables.PHENIX_DEV = "1";
    };
  };
}
