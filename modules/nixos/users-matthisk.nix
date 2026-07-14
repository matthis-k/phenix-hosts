{ inputs }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeNetworkPublicKey = builtins.readFile ../../secrets/home_network_id.pub;
in
{
  imports = [
    (import ./home-manager.nix { inherit inputs; })
    (import ./sops.nix { inherit inputs; })
    ./dev-mode.nix
  ];

  users.users.matthisk = {
    isNormalUser = true;
    initialPassword = lib.mkDefault "";
    description = "matthisk";
    openssh.authorizedKeys.keys = [ homeNetworkPublicKey ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  sops.secrets = {
    home_network_id = {
      format = "binary";
      mode = "0600";
      owner = "matthisk";
      path = "/run/secrets/home_network_id";
      sopsFile = ../../secrets/home_network_id;
    };

    github_id = {
      format = "binary";
      mode = "0600";
      owner = "matthisk";
      path = "/run/secrets/github_id";
      sopsFile = ../../secrets/github_id;
    };

    github_token = {
      format = "binary";
      mode = "0600";
      owner = "matthisk";
      path = "/run/secrets/github_token";
      sopsFile = ../../secrets/github_token;
    };
  };

  home-manager.users.matthisk = {
    imports = [ (import ../home/matthisk.nix { inherit inputs; }) ];
    phenix.devMode = config.phenix.devMode;

    home.file.".config/hypr/nix-import.lua" = lib.mkIf config.phenix.de.hyprland.enableRuntimeLuaImport {
      source = lib.mkForce (
        pkgs.runCommand "phenix-hyprland-nix-import-symlink" { } ''
          ln -s /run/phenix/hypr/nix-import.lua "$out"
        ''
      );
    };
  };

  security.sudo.extraRules = lib.mkAfter [
    {
      users = [ "matthisk" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/cat /var/lib/sops-nix/key.txt";
          options = [ "PASSWD" ];
        }
      ];
    }
  ];
}
