{
  imports = [
    ../hardware/desktop.nix
    ../storage/desktop.nix
    ../boot/desktop.nix
    ../services/llm-server.nix
  ];

  networking.hostName = "matthisk-desktop-newxos";

  phenix.de.hyprland.monitors = [ ];

  newxos.nordvpn.technology = "NORDLYNX";

  services.llm-server.enableTTS = true;
}
