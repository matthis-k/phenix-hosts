_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "phenix-hosts-dev";
        packages = with pkgs; [
          devenv
          git
          nix
        ];
        shellHook = ''
          echo "phenix-hosts dev shell"
          echo "  maintenance: devenv test"
          echo "  fixes:       devenv tasks run maintenance:fix"
        '';
      };
    };
}
