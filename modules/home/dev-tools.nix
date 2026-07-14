{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.phenix.devTools;
in
{
  options.phenix.devTools = {
    enable = lib.mkEnableOption "the general-purpose Phenix development CLI toolkit";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        bat
        curl
        entr
        eza
        fd
        file
        hyperfine
        jq
        just
        moreutils
        ripgrep
        shellcheck
        shfmt
        tree
        unzip
        wget
        yq-go
        zip
      ];
      defaultText = lib.literalExpression "with pkgs; [ bat curl entr eza fd file hyperfine jq just moreutils ripgrep shellcheck shfmt tree unzip wget yq-go zip ]";
      description = "General-purpose command-line tools installed for development and repository work.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;
  };
}
