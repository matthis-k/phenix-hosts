{ inputs }:
{
  imports = [
    (import ../workstation.nix { inherit inputs; })
    ../hardware/laptop.nix
    ../storage/laptop.nix
    ../boot/laptop.nix
  ];

  networking.hostName = "matthisk-laptop-newxos";

  phenix.de.hyprland = {
    monitors = [
      {
        output = "eDP-1";
        mode = "1920x1080";
        position = "0x0";
        scale = 1;
      }
    ];
    enableRuntimeLuaImport = true;
  };

  newxos.nordvpn = {
    enable = true;
    technology = "OPENVPN";
  };

  sops.secrets.nordvpn_token = {
    format = "binary";
    mode = "0400";
    path = "/run/secrets/nordvpn_token";
    sopsFile = ../../../secrets/nordvpn_token;
  };

  services.displayManager.autoLogin.user = "matthisk";
  system.stateVersion = "25.11";
}
