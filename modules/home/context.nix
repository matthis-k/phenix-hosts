{ inventory }:
{
  lib,
  osConfig ? null,
  ...
}:
let
  primaryUser = inventory.users.${inventory.primaryUser};
  fromHost =
    path: fallback:
    if osConfig == null then fallback else lib.attrByPath ([ "phenix" ] ++ path) fallback osConfig;
  readOnlyString =
    default: description:
    lib.mkOption {
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
      name = readOnlyString (fromHost [
        "user"
        "name"
      ] primaryUser.name) "Primary interactive user managed by Phenix.";
      homeDirectory = readOnlyString (fromHost [
        "user"
        "homeDirectory"
      ] primaryUser.homeDirectory) "Home directory of the primary Phenix user.";

      git = {
        name = readOnlyString (fromHost [
          "user"
          "git"
          "name"
        ] primaryUser.git.name) "Git author name of the primary Phenix user.";
        email = readOnlyString (fromHost [
          "user"
          "git"
          "email"
        ] primaryUser.git.email) "Git author email of the primary Phenix user.";
      };
    };

    paths = {
      root = readOnlyString (fromHost [
        "paths"
        "root"
      ] primaryUser.workspace.root) "Root directory of the local Phenix workspace.";
      repositories = readOnlyString (fromHost [
        "paths"
        "repositories"
      ] primaryUser.workspace.repositories) "Directory containing the Phenix repositories.";
      flake = readOnlyString (fromHost [
        "paths"
        "flake"
      ] primaryUser.workspace.flake) "Path to the root Phenix flake checkout.";
      desktop = readOnlyString (fromHost [
        "paths"
        "desktop"
      ] primaryUser.workspace.desktop) "Path to the Phenix desktop checkout.";
      secrets = readOnlyString (fromHost [
        "paths"
        "secrets"
      ] inventory.secretDirectory) "Runtime directory containing decrypted Phenix secrets.";
    };

    versions.homeManager = readOnlyString (fromHost [
      "versions"
      "homeManager"
    ] primaryUser.stateVersion) "Home Manager state version of the primary user.";
  };

  config.phenix.devMode = lib.mkDefault (fromHost [ "devMode" ] false);
}
