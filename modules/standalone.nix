{ inputs, ... }: let
  inherit (inputs) nixpkgs disko;
in {
  flake.nixosConfigurations = {
    matthisk-laptop = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        ./hosts/matthisk-laptop/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };

    matthisk-desktop = nixpkgs.lib.nixosSystem {
      modules = [
        disko.nixosModules.disko
        ./hosts/matthisk-desktop/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };

    phenix-live-usb = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/phenix-live-usb/configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
      ];
    };
  };

  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "phenix-hosts-dev";
      packages = with pkgs; [ nix nixfmt statix deadnix ];
      shellHook = ''
        repo-hook() {
          if command -v tend &>/dev/null; then
            tend check --profile git-hook --staged "$@"
          else
            echo "tend not available — enter the root Phenix dev shell" >&2
            return 1
          fi
        }
        repo-pushgate() {
          if command -v tend &>/dev/null; then
            tend check --profile pre-push "$@"
          else
            echo "tend not available — enter the root Phenix dev shell" >&2
            return 1
          fi
        }
        repo-check() {
          if command -v tend &>/dev/null; then
            tend check --profile manual "$@"
          else
            echo "tend not available — enter the root Phenix dev shell" >&2
            return 1
          fi
        }
        repo-fix() {
          if command -v tend &>/dev/null; then
            tend check --profile fix "$@"
          else
            echo "tend not available — enter the root Phenix dev shell" >&2
            return 1
          fi
        }
        export -f repo-hook repo-pushgate repo-check repo-fix 2>/dev/null || true
        echo "phenix-hosts dev shell"
        echo "  tools: nix nixfmt statix deadnix"
        if command -v tend &>/dev/null; then
          echo "  repo-hook      -> tend check --profile git-hook --staged"
          echo "  repo-pushgate  -> tend check --profile pre-push"
          echo "  repo-check     -> tend check --profile manual"
          echo "  repo-fix       -> tend check --profile fix"
        fi
      '';
    };
  };
}
