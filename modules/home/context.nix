{ inventory }:
{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  primaryUser = inventory.users.${inventory.primaryUser};
  fromHost = fallback: selector: if osConfig == null then fallback else selector osConfig.phenix;
  readOnlyString = default: description: lib.mkOption {
    inherit default description;
    type = lib.types.str;
    readOnly = true;
  };
in
{
  options.phenix = {
    devMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use live Phenix desktop configuration sources.";
    };

    user = {
      name = readOnlyString
        (fromHost primaryUser.name (phenix: phenix.user.name))
        "Primary interactive user managed by Phenix.";
      homeDirectory = readOnlyString
        (fromHost primaryUser.homeDirectory (phenix: phenix.user.homeDirectory))
        "Home directory of the primary Phenix user.";

      git = {
        name = readOnlyString
          (fromHost primaryUser.git.name (phenix: phenix.user.git.name))
          "Git author name of the primary Phenix user.";
        email = readOnlyString
          (fromHost primaryUser.git.email (phenix: phenix.user.git.email))
          "Git author email of the primary Phenix user.";
      };
    };

    paths = {
      root = readOnlyString
        (fromHost primaryUser.workspace.root (phenix: phenix.paths.root))
        "Root directory of the local Phenix workspace.";
      repositories = readOnlyString
        (fromHost primaryUser.workspace.repositories (phenix: phenix.paths.repositories))
        "Directory containing the Phenix repositories.";
      flake = readOnlyString
        (fromHost primaryUser.workspace.flake (phenix: phenix.paths.flake))
        "Path to the root Phenix flake checkout.";
      desktop = readOnlyString
        (fromHost primaryUser.workspace.desktop (phenix: phenix.paths.desktop))
        "Path to the Phenix desktop checkout.";
      secrets = readOnlyString
        (fromHost inventory.secretDirectory (phenix: phenix.paths.secrets))
        "Runtime directory containing decrypted Phenix secrets.";
    };

    versions.homeManager = readOnlyString
      (fromHost primaryUser.stateVersion (phenix: phenix.versions.homeManager))
      "Home Manager state version of the primary user.";
  };

  config = {
    phenix.devMode = lib.mkDefault (
      if osConfig == null then false else osConfig.phenix.devMode or false
    );

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
  };
}
