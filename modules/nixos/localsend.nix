{ inputs }:
{ config, pkgs, ... }:
let
  port = 53317;
  settingsFile = pkgs.writeText "localsend-settings.json" (
    builtins.toJSON {
      "flutter.ls_version" = 2;
      "flutter.ls_port" = port;
      "flutter.ls_alias" = config.networking.hostName;
    }
  );

  localsend = pkgs.writeShellApplication {
    name = "localsend_app";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      settings_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/org.localsend.localsend_app"
      settings_file="$settings_dir/shared_preferences.json"
      mkdir -p "$settings_dir"

      if [ -f "$settings_file" ]; then
        tmp_file="$(mktemp)"
        jq -s '.[0] * .[1]' "$settings_file" ${settingsFile} > "$tmp_file"
        mv "$tmp_file" "$settings_file"
      else
        cp ${settingsFile} "$settings_file"
      fi

      exec ${pkgs.localsend}/bin/localsend_app "$@"
    '';
  };
in
{
  imports = [ (import ./services/nordvpn.nix { inherit inputs; }) ];

  environment.systemPackages = [ localsend ];

  networking.firewall = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };

  services.nordvpn.settings.allowlist.ports = [
    {
      inherit port;
      protocol = "TCP";
    }
    {
      inherit port;
      protocol = "UDP";
    }
  ];
}
