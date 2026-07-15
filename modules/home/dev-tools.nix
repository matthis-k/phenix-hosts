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
    enable = lib.mkEnableOption "the language-agnostic Phenix terminal and development toolkit";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        bat
        bzip2
        coreutils
        curl
        diffutils
        eza
        fd
        file
        findutils
        gawk
        gh
        gitFull
        gnumake
        gnugrep
        gnused
        gnutar
        gzip
        hyperfine
        jq
        just
        moreutils
        patch
        ripgrep
        rsync
        tokei
        tree
        unzip
        wget
        which
        xz
        yq-go
        zip
      ];
      defaultText = lib.literalExpression "with pkgs; [ bat bzip2 coreutils curl diffutils eza fd file findutils gawk gh gitFull gnumake gnugrep gnused gnutar gzip hyperfine jq just moreutils patch ripgrep rsync tokei tree unzip wget which xz yq-go zip ]";
      description = "Language-agnostic command-line utilities for terminal use, repository work, builds, data processing, archives, and measurement.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;
  };
}
