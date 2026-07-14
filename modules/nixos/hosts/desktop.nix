{ host }:
{
  imports = [
    ../hardware/desktop.nix
    ../storage/desktop.nix
    ../boot/desktop.nix
    ../services/llm-server.nix
  ];

  networking.hostName = host.hostName;

  phenix = {
    host.role = host.role;
    de.hyprland.monitors = [ ];
    nordvpn.technology = "NORDLYNX";
  };

  services.llm-server.enableTTS = true;
}
