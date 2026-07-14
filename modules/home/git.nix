{ lib, pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        user = {
          name = "matthis-k";
          email = "matthis.kaelble@gmail.com";
        };
        pull.rebase = false;
        merge.conflictstyle = "diff3";
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    gh.enable = true;
    lazygit.enable = true;

    fish.interactiveShellInit = lib.mkAfter ''
      if test -r /run/secrets/github_token
        set -l github_token (string trim < /run/secrets/github_token)

        if test -n "$github_token"
          set -gx GH_TOKEN $github_token
          set -gx GITHUB_TOKEN $github_token
          set -gx GITHUB_PERSONAL_ACCESS_TOKEN $github_token
        end
      end
    '';

    ssh.settings."github.com" = {
      AddKeysToAgent = "yes";
      HostName = "github.com";
      IdentitiesOnly = true;
      IdentityFile = "/run/secrets/github_id";
      User = "git";
    };
  };
}
