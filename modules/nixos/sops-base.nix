{ inputs }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  systemd.tmpfiles.rules = [
    "d /var/lib/sops-nix 0700 root root - -"
  ];
}
