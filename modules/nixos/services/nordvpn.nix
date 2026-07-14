{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.newxos.nordvpn;
  nordvpn = "/run/current-system/sw/bin/nordvpn";
  groupArgs = lib.optionals cfg.dedicatedIp [
    "--group"
    "Dedicated_IP"
  ];
  connectArgs = lib.escapeShellArgs ([ "connect" ] ++ groupArgs);
  autoConnectArgs = lib.escapeShellArgs (
    [
      "set"
      "autoconnect"
      "true"
    ]
    ++ groupArgs
  );
in
{
  options.newxos.nordvpn = {
    enable = lib.mkEnableOption "the migrated NordVPN workstation configuration";

    technology = lib.mkOption {
      type = lib.types.enum [
        "NORDLYNX"
        "OPENVPN"
        "NORDWHISPER"
      ];
      default = "OPENVPN";
      description = "NordVPN connection technology.";
    };

    dedicatedIp = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Connect through the Dedicated_IP server group.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nordvpn.enable = true;

    users.users.matthisk.extraGroups = [ "nordvpn" ];

    systemd.services.nordvpn-bootstrap = {
      description = "Apply the declarative NordVPN workstation settings";
      after = [
        "network-online.target"
        "nordvpnd.service"
      ]
      ++ lib.optional config.networking.networkmanager.enable "NetworkManager-wait-online.service";
      wants = [
        "network-online.target"
        "nordvpnd.service"
      ]
      ++ lib.optional config.networking.networkmanager.enable "NetworkManager-wait-online.service";
      wantedBy = [ "multi-user.target" ];

      restartTriggers = [
        cfg.technology
        (toString cfg.dedicatedIp)
      ];

      path = [
        pkgs.coreutils
        pkgs.gnugrep
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "matthisk";
        SupplementaryGroups = [ "nordvpn" ];
      };

      script = ''
        set -euo pipefail

        attempt=0
        until ${nordvpn} settings >/dev/null 2>&1; do
          attempt=$((attempt + 1))
          if [ "$attempt" -ge 30 ]; then
            echo "NordVPN CLI did not become ready" >&2
            exit 1
          fi
          sleep 1
        done

        if ! ${nordvpn} account >/dev/null 2>&1; then
          token="$(tr -d '\r\n' < /run/secrets/nordvpn_token)"
          ${nordvpn} login --token "$token"
        fi

        nordvpn_set() {
          output="$(${nordvpn} set "$@" 2>&1)" && {
            printf '%s\n' "$output"
            return 0
          }

          case "$output" in
            *already*)
              printf '%s\n' "$output"
              return 0
              ;;
          esac

          printf '%s\n' "$output" >&2
          return 1
        }

        allowlist_add() {
          output="$(${nordvpn} allowlist add "$@" 2>&1)" && {
            printf '%s\n' "$output"
            return 0
          }

          case "$output" in
            *"already allowlisted"*)
              printf '%s\n' "$output"
              return 0
              ;;
          esac

          printf '%s\n' "$output" >&2
          return 1
        }

        nordvpn_set technology ${lib.escapeShellArg cfg.technology}
        nordvpn_set firewall enabled
        nordvpn_set routing enabled
        nordvpn_set analytics disabled
        nordvpn_set killswitch disabled
        nordvpn_set threatprotectionlite disabled
        nordvpn_set notify enabled
        nordvpn_set tray enabled
        nordvpn_set ipv6 disabled
        nordvpn_set meshnet disabled
        nordvpn_set lan-discovery enabled
        nordvpn_set virtual-location enabled
        nordvpn_set post-quantum disabled
        nordvpn_set dns false
        allowlist_add port 5353 protocol UDP
        allowlist_add subnet 224.0.0.0/24
        ${nordvpn} ${autoConnectArgs}

        if ! ${nordvpn} status | grep -q 'Status: Connected'; then
          ${nordvpn} ${connectArgs}
        fi
      '';
    };
  };
}
