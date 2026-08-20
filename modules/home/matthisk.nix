{ inputs, inventory }:
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  harnessPackage = inputs.phenix-harness.packages.${system}.default;
  enableRuntimeLuaImport =
    osConfig != null
    && lib.attrByPath [
      "phenix"
      "de"
      "hyprland"
      "enableRuntimeLuaImport"
    ] false osConfig;
  phenixCli = pkgs.writeShellApplication {
    name = "phenix";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      default_flake=${lib.escapeShellArg config.phenix.paths.flake}
      command="''${1:-}"
      case "$command" in
        switch)
          shift
          flake="''${PHENIX_FLAKE:-$default_flake}"
          if [ ! -e "$flake/flake.nix" ]; then
            flake="github:matthis-k/phenix"
          fi
          host="''${PHENIX_HOST:-$(${pkgs.coreutils}/bin/cat /etc/hostname)}"
          exec /run/wrappers/bin/sudo /run/current-system/sw/bin/nixos-rebuild \
            switch --flake "$flake#$host" "$@"
          ;;
        reload-shell)
          shift
          exec ${pkgs.systemd}/bin/systemctl --user restart phenix-shell.service "$@"
          ;;
        *)
          echo "usage: phenix {switch|reload-shell}" >&2
          exit 2
          ;;
      esac
    '';
    meta.description = "Operate the local Phenix workstation";
  };
in
{
  imports = [
    (import ./context.nix { inherit inventory; })
    ./users-matthisk-base.nix
    (import ./users-matthisk-ssh.nix { inherit inventory; })
    ./dev-tools.nix
    ./git.nix
    inputs.phenix-de.homeModules.default
  ];

  config = {
    phenix.devTools.enable = true;

    home = {
      packages = [
        phenixCli
        inputs.phenix-nvim.packages.${system}.nvim-nix
        harnessPackage
      ];

      file.".config/hypr/nix-import.lua" = lib.mkIf enableRuntimeLuaImport {
        source = lib.mkForce (
          pkgs.runCommand "phenix-hyprland-nix-import-symlink" { } ''
            ln -s /run/phenix/hypr/nix-import.lua "$out"
          ''
        );
      };
    };
  };
}
