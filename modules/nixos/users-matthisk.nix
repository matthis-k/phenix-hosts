{ config, lib, ... }:
let
  user = config.phenix.user;
  secretPath = name: "${config.phenix.paths.secrets}/${name}";
  homeNetworkPublicKey = builtins.readFile ../../secrets/home_network_id.pub;
in
{
  users.mutableUsers = false;

  users.users.${user.name} = {
    isNormalUser = true;
    hashedPassword = "!";
    description = user.name;
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
      owner = user.name;
      path = secretPath "home_network_id";
      sopsFile = ../../secrets/home_network_id;
    };

    github_id = {
      format = "binary";
      mode = "0600";
      owner = user.name;
      path = secretPath "github_id";
      sopsFile = ../../secrets/github_id;
    };

    github_token = {
      format = "binary";
      mode = "0600";
      owner = user.name;
      path = secretPath "github_token";
      sopsFile = ../../secrets/github_token;
    };
  };

  security.sudo.extraRules = lib.mkAfter [
    {
      users = [ user.name ];
      commands = [
        {
          command = "/run/current-system/sw/bin/cat /var/lib/sops-nix/key.txt";
          options = [ "PASSWD" ];
        }
      ];
    }
  ];
}
