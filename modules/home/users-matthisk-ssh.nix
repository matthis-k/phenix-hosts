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

      "matthisk-desktop-phenix desktop" = {
        HostName = "matthisk-desktop-phenix.local";
        IdentitiesOnly = true;
        IdentityFile = "/run/secrets/home_network_id";
        User = "matthisk";
      };

      "matthisk-laptop-phenix laptop" = {
        HostName = "matthisk-laptop-phenix.local";
        IdentitiesOnly = true;
        IdentityFile = "/run/secrets/home_network_id";
        User = "matthisk";
      };
    };
  };
}
