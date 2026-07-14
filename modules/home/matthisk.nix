{ inputs }:
{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  piPackage = inputs.phenix-agent-harness.packages.${system}.pi;
  hostDevMode = if osConfig == null then false else osConfig.phenix.devMode or false;
  enableRuntimeLuaImport =
    osConfig != null && (osConfig.phenix.de.hyprland.enableRuntimeLuaImport or false);
  phenixCli = pkgs.writeShellApplication {
    name = "phenix";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      command="''${1:-}"
      case "$command" in
        ai)
          shift
          workspace="''${PHENIX_FLAKE:-$HOME/phenix/repos/phenix}"
          if [ ! -d "$workspace" ]; then
            echo "Phenix workspace not found at $workspace" >&2
            exit 1
          fi
          cd "$workspace"
          exec ${piPackage}/bin/pi "$@"
          ;;
        switch)
          shift
          flake="''${PHENIX_FLAKE:-$HOME/phenix/repos/phenix}"
          if [ ! -e "$flake/flake.nix" ]; then
            flake="github:matthis-k/phenix"
          fi
          host="''${PHENIX_HOST:-$(${pkgs.coreutils}/bin/cat /etc/hostname)}"
          exec /run/wrappers/bin/sudo /run/current-system/sw/bin/nixos-rebuild             switch --flake "$flake#$host" "$@"
          ;;
        reload-shell)
          shift
          exec ${pkgs.systemd}/bin/systemctl --user restart phenix-shell.service "$@"
          ;;
        *)
          echo "usage: phenix {ai|switch|reload-shell}" >&2
          exit 2
          ;;
      esac
    '';
    meta.description = "Operate the local Phenix workstation";
  };
in
{
  imports = [
    ./users-matthisk-base.nix
    ./users-matthisk-ssh.nix
    ./git.nix
    inputs.phenix-de.homeModules.default
  ];

  options.phenix.devMode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Use live Phenix desktop configuration sources.";
  };

  config = {
    phenix.devMode = lib.mkDefault hostDevMode;

    home = {
      packages = [
        phenixCli
        inputs.phenix-nvim.packages.${system}.nvim-nix
        piPackage
      ];

      file.".config/hypr/nix-import.lua" = lib.mkIf enableRuntimeLuaImport {
        source = lib.mkForce (
          pkgs.runCommand "phenix-hyprland-nix-import-symlink" { } ''
            ln -s /run/phenix/hypr/nix-import.lua "$out"
          ''
        );
      };

      sessionVariables = {
        PHENIX_ROOT = "${config.home.homeDirectory}/phenix";
        PHENIX_FLAKE = "${config.home.homeDirectory}/phenix/repos/phenix";
        PHENIX_DE_ROOT = "${config.home.homeDirectory}/phenix/repos/phenix-de";
      }
      // lib.optionalAttrs config.phenix.devMode {
        PHENIX_DEV = "1";
      };
    };
  };
}
