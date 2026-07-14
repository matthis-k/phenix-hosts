{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.phenix.nordvpn;
  nordvpn = "${pkgs.nordvpn}/bin/nordvpn";
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
  options.phenix.nordvpn = {
    enable = lib.mkEnableOption "the declarative NordVPN workstation configuration";

    technology = lib.mkOption {
      type = lib.types.enum [
        "NORDLYNX"
        "OPENVPN"
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

    networking.firewall.checkReversePath = "loose";
    users.users.matthisk.extraGroups = [ "nordvpn" ];

    systemd.services.nordvpn-bootstrap = {
      description = "Apply the declarative NordVPN workstation settings";
      after = [
        "network-online.target"
        "nordvpnd.service"
        "nordvpnd.socket"
      ]
      ++ lib.optional config.networking.networkmanager.enable "NetworkManager-wait-online.service";
      requires = [
        "nordvpnd.service"
        "nordvpnd.socket"
      ];
      wants = [ "network-online.target" ]
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
        TimeoutStartSec = "2min";
      };

      script = ''
        set -euo pipefail

        last_error=""
        for attempt in $(seq 1 60); do
          if output="$(${nordvpn} settings 2>&1)"; then
            break
          fi
          last_error="$output"
          if [ "$attempt" -eq 60 ]; then
            printf 'NordVPN CLI did not become ready: %s\n' "$last_error" >&2
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
        allowlist_add port 53317 protocol TCP
        allowlist_add port 53317 protocol UDP
        ${nordvpn} ${autoConnectArgs}

        if ! ${nordvpn} status | grep -q 'Status: Connected'; then
          ${nordvpn} ${connectArgs}
        fi
      '';
    };
  };
}
