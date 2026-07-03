{ inputs, ... }:
let
  nixosModules = {
    default = import ./nixos/default.nix { inherit inputs; };
    phenixMigrationBase = import ./nixos/phenix-migration-base.nix;
    homeManagerBridge = import ./nixos/home-manager-bridge.nix { inherit inputs; };
    sopsBridge = import ./nixos/sops-bridge.nix;
    sopsBase = import ./nixos/sops-base.nix { inherit inputs; };
    nixBase = import ./nixos/nix-base.nix;
    usersMatthisk = import ./nixos/users-matthisk.nix;
    localeDeEn = import ./nixos/locale-de-en.nix;
    audioPipewire = import ./nixos/audio-pipewire.nix;
    sudoWheelPasswordless = import ./nixos/sudo-wheel-passwordless.nix;
  };

  homeModules = {
    usersMatthiskBase = import ./home/users-matthisk-base.nix;
    usersMatthiskSsh = import ./home/users-matthisk-ssh.nix;
  };
in
{
  # Host configuration files are not present in this repository checkout yet.
  # Keep nixosConfigurations empty until real hosts/<name>/configuration.nix
  # files exist and have been verified before enabling imports here.
  flake = {
    nixosConfigurations = { };

    inherit nixosModules homeModules;
  };

  perSystem = { pkgs, ... }: {
    packages.phenix-migration-info = pkgs.writeShellApplication {
      name = "phenix-migration-info";
      text = ''
        cat <<'EOF'
        Phenix NewXOS migration groundwork

        Status: first adoption slice is API groundwork only.

        Available NixOS module surfaces:
        - phenix-hosts.nixosModules.default
        - phenix-hosts.nixosModules.phenixMigrationBase
        - phenix-hosts.nixosModules.homeManagerBridge
        - phenix-hosts.nixosModules.sopsBridge
        - phenix-hosts.nixosModules.sopsBase
        - phenix-hosts.nixosModules.nixBase
        - phenix-hosts.nixosModules.usersMatthisk
        - phenix-hosts.nixosModules.localeDeEn
        - phenix-hosts.nixosModules.audioPipewire
        - phenix-hosts.nixosModules.sudoWheelPasswordless

        Available Home Manager module surfaces:
        - phenix-hosts.homeModules.usersMatthiskBase
        - phenix-hosts.homeModules.usersMatthiskSsh

        Deferred migration chunks:
        - host enablement and behavior migration
        - concrete Home Manager user imports
        - secrets activation and secret payload migration
        - GitHub credential migration
        - nix-ld migration
        - OpenSSH server enablement
        - Hyprland, dev-tools, shell/browser/VPN/theming, hardware, and workflow migrations
        EOF
      '';
    };

    devShells.default = pkgs.mkShell {
      name = "phenix-hosts-dev";
      packages = with pkgs; [
        nix
        nixfmt
        statix
        deadnix
      ];
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
