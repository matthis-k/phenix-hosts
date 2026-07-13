{ inputs }:
{
  config,
  lib,
  ...
}:
let
  cfg = config.phenix.sops;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.phenix.sops = {
    enable = lib.mkEnableOption "the Phenix sops-nix integration";

    ageKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sops-nix/key.txt";
      description = "Path to the host age identity used by sops-nix.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.age.keyFile = cfg.ageKeyFile;
    systemd.tmpfiles.rules = [ "d /var/lib/sops-nix 0700 root root - -" ];
  };
}
