{ pkgs, ... }:
let
  root = ''repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"; cd "$repo_root"'';
  nixSources = "find . -type f -name '*.nix' -not -path './.git/*' -not -path './.devenv/*' -not -path './result*/*'";
in
{
  scripts = {
    "maintenance-check-format" = {
      packages = [
        pkgs.findutils
        pkgs.git
        pkgs.nixfmt
      ];
      exec = "${root}; ${nixSources} -exec nixfmt --check {} +";
    };
    "maintenance-check-statix" = {
      packages = [
        pkgs.git
        pkgs.statix
      ];
      exec = "${root}; statix check --ignore '.git/**' ";
    };
    "maintenance-check-deadnix" = {
      packages = [
        pkgs.deadnix
        pkgs.git
      ];
      exec = "${root}; deadnix --fail --no-lambda-arg --no-lambda-pattern-names";
    };
    "maintenance-check-flake" = {
      packages = [
        pkgs.git
        pkgs.nix
      ];
      exec = "${root}; nix flake check --accept-flake-config --print-build-logs --keep-going";
    };
    "maintenance-check-hosts" = {
      packages = [
        pkgs.git
        pkgs.nix
      ];
      exec = ''
        ${root}
        for host in matthisk-laptop-phenix matthisk-desktop-phenix; do
          nix eval --accept-flake-config --raw \
            ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath" >/dev/null
        done
      '';
    };
    "maintenance-check-agent-boundary" = {
      packages = [ pkgs.git ];
      exec = ''
        ${root}
        legacy_agent="$(printf 'phenix-agent-%s' 'harness')"
        legacy_opencode="$(printf 'phenix-%s' 'opencode')"
        legacy_pi="$(printf 'pi-%s' 'src')"
        for legacy in "$legacy_agent" "$legacy_opencode" "$legacy_pi"; do
          ! git grep -nF "$legacy" -- . ':(exclude).github/workflows/**'
        done
      '';
    };
    "maintenance-fix-statix" = {
      packages = [
        pkgs.git
        pkgs.statix
      ];
      exec = "${root}; statix fix";
    };
    "maintenance-fix-deadnix" = {
      packages = [
        pkgs.deadnix
        pkgs.git
      ];
      exec = "${root}; deadnix --edit --no-lambda-arg --no-lambda-pattern-names";
    };
    "maintenance-fix-format" = {
      packages = [
        pkgs.findutils
        pkgs.git
        pkgs.nixfmt
      ];
      exec = "${root}; ${nixSources} -exec nixfmt {} +";
    };
  };

  tasks = {
    "maintenance:format".exec = "maintenance-check-format";
    "maintenance:statix".exec = "maintenance-check-statix";
    "maintenance:deadnix".exec = "maintenance-check-deadnix";
    "maintenance:flake".exec = "maintenance-check-flake";
    "maintenance:hosts".exec = "maintenance-check-hosts";
    "maintenance:agent-boundary".exec = "maintenance-check-agent-boundary";

    "maintenance:check" = {
      exec = "true";
      after = [
        "maintenance:format"
        "maintenance:statix"
        "maintenance:deadnix"
        "maintenance:flake"
        "maintenance:hosts"
        "maintenance:agent-boundary"
      ];
      before = [ "devenv:enterTest" ];
    };

    "maintenance:fix:statix".exec = "maintenance-fix-statix";
    "maintenance:fix:deadnix" = {
      exec = "maintenance-fix-deadnix";
      after = [ "maintenance:fix:statix" ];
    };
    "maintenance:fix:format" = {
      exec = "maintenance-fix-format";
      after = [ "maintenance:fix:deadnix" ];
    };
    "maintenance:fix" = {
      exec = "true";
      after = [ "maintenance:fix:format" ];
    };
  };
}
