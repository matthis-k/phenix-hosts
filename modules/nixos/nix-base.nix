{ inputs }:
{
  config,
  lib,
  ...
}:
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    cudaSupport = true;
  };

  nix = {
    registry = lib.mapAttrs (_: flake: { inherit flake; }) (
      lib.filterAttrs (_: value: lib.isType "flake" value) inputs
    );

    nixPath = [ "/etc/nix/path" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
    };
  };

  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  programs.nix-ld.enable = true;
}
