{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
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
    };
}
