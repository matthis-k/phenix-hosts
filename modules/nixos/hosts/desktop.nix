{ inputs }:
{
  imports = [
    (import ../workstation.nix { inherit inputs; })
    ../hardware/desktop.nix
    ../storage/desktop.nix
    ../boot/desktop.nix
    ../services/llm-server.nix
  ];

  networking.hostName = "matthisk-desktop-newxos";

  phenix.de.hyprland.monitors = [ ];

  newxos.nordvpn = {
    enable = true;
    technology = "NORDLYNX";
  };

  sops.secrets.nordvpn_token = {
    format = "binary";
    mode = "0400";
    path = "/run/secrets/nordvpn_token";
    sopsFile = ../../../secrets/nordvpn_token;
  };

  services.llm-server.enableTTS = true;
  services.displayManager.autoLogin.user = "matthisk";
  system.stateVersion = "25.11";
}
