{
  imports = [
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

  newxos.nordvpn.technology = "OPENVPN";
}
