{
  config,
  lib,
  pkgs,
  ...
}:
let
  githubIdentityPath = "${config.phenix.paths.secrets}/github_id";
  githubTokenPath = "${config.phenix.paths.secrets}/github_token";
in
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        user = {
          name = config.phenix.user.git.name;
          email = config.phenix.user.git.email;
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
      if test -r ${githubTokenPath}
        set -l github_token (string trim < ${githubTokenPath})

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
      IdentityFile = githubIdentityPath;
      User = "git";
    };
  };
}
