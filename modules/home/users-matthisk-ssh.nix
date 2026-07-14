{ inventory }:
{ config, lib, ... }:
let
  hostSettings = lib.mapAttrs' (
    _: host:
    lib.nameValuePair "${host.hostName} ${host.role}" {
      HostName = host.localHostName;
      IdentitiesOnly = true;
      IdentityFile = "${config.phenix.paths.secrets}/home_network_id";
      User = config.phenix.user.name;
    }
  ) inventory.hosts;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    }
    // hostSettings;
  };
}
