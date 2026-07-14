let
  localDomain = "local";
  primaryUser = "matthisk";

  users = {
    matthisk = rec {
      name = primaryUser;
      homeDirectory = "/home/${name}";
      stateVersion = "26.05";

      git = {
        name = "matthis-k";
        email = "matthis.kaelble@gmail.com";
      };

      workspace = rec {
        root = "${homeDirectory}/phenix";
        repositories = "${root}/repos";
        flake = "${repositories}/phenix";
        desktop = "${repositories}/phenix-de";
      };
    };
  };

  mkHost = role: hostName: {
    inherit hostName role;
    localHostName = "${hostName}.${localDomain}";
    inherit primaryUser;
  };
in
{
  inherit localDomain primaryUser users;

  nixosStateVersion = "25.11";
  secretDirectory = "/run/secrets";

  hosts = {
    laptop = mkHost "laptop" "matthisk-laptop-phenix";
    desktop = mkHost "desktop" "matthisk-desktop-phenix";
  };
}
