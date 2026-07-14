{ config, lib, ... }:
{
  home = {
    username = config.phenix.user.name;
    homeDirectory = config.phenix.user.homeDirectory;
    stateVersion = config.phenix.versions.homeManager;

    sessionVariables = {
      PHENIX_ROOT = config.phenix.paths.root;
      PHENIX_FLAKE = config.phenix.paths.flake;
      PHENIX_DE_ROOT = config.phenix.paths.desktop;
    }
    // lib.optionalAttrs config.phenix.devMode {
      PHENIX_DEV = "1";
    };
  };

  programs.home-manager.enable = true;
}
