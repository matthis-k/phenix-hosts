{ lib, ... }:
let
  homeNetworkPublicKey = builtins.readFile ../../secrets/home_network_id.pub;
in
{
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
