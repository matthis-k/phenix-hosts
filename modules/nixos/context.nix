{ inventory }:
{ config, lib, ... }:
let
  primaryUser = inventory.users.${inventory.primaryUser};
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
    host = {
      role = lib.mkOption {
        type = lib.types.enum [
          "workstation"
          "laptop"
          "desktop"
        ];
        default = "workstation";
        description = "Role of this Phenix host.";
      };

      localDomain = readOnlyString
        inventory.localDomain
        "Local discovery domain used by Phenix hosts.";
      localName = readOnlyString
        "${config.networking.hostName}.${config.phenix.host.localDomain}"
        "Fully qualified local discovery name of this host.";
    };

    user = {
      name = readOnlyString
        primaryUser.name
        "Primary interactive user managed by Phenix.";
      homeDirectory = readOnlyString
        primaryUser.homeDirectory
        "Home directory of the primary Phenix user.";

      git = {
        name = readOnlyString
          primaryUser.git.name
          "Git author name of the primary Phenix user.";
        email = readOnlyString
          primaryUser.git.email
          "Git author email of the primary Phenix user.";
      };
    };

    paths = {
      root = readOnlyString
        primaryUser.workspace.root
        "Root directory of the local Phenix workspace.";
      repositories = readOnlyString
        primaryUser.workspace.repositories
        "Directory containing the Phenix repositories.";
      flake = readOnlyString
        primaryUser.workspace.flake
        "Path to the root Phenix flake checkout.";
      desktop = readOnlyString
        primaryUser.workspace.desktop
        "Path to the Phenix desktop checkout.";
      secrets = readOnlyString
        inventory.secretDirectory
        "Runtime directory containing decrypted Phenix secrets.";
    };

    versions = {
      nixos = readOnlyString
        inventory.nixosStateVersion
        "NixOS state version shared by Phenix hosts.";
      homeManager = readOnlyString
        primaryUser.stateVersion
        "Home Manager state version of the primary user.";
    };
  };
}
