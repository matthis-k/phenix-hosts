{
  imports = [
    ../hardware/desktop.nix
    ../storage/desktop.nix
    ../boot/desktop.nix
    ../services/llm-server.nix
  ];

  networking.hostName = "matthisk-desktop-phenix";

  phenix.de.hyprland.monitors = [ ];

  phenix.nordvpn.technology = "NORDLYNX";

  services.llm-server.enableTTS = true;
}
