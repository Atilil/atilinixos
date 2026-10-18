{inputs, ...}: {
  # Permanent WireGuard client to the admin's UniFi gateway (split tunnel).
  # Values are inline: only the ideapad uses it.
  den.aspects.vpn.os = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # Per-host sops file holding `wireguard_private_key`.
    secretsFile = ../../hosts/ideapad/sops/secrets.yaml;
    # sops-nix fails the build if the file is missing: skip the VPN until it exists.
    ready = builtins.pathExists secretsFile;
  in {
    imports = [inputs.sops-nix.nixosModules.sops];

    config = lib.mkMerge [
      {
        warnings = lib.optional (!ready) ''
          vpn aspect: ${toString secretsFile} does not exist yet; WireGuard is NOT
          configured and SSH/RDP stay open on every interface.
        '';
      }

      (lib.mkIf ready {
        # Age identity derived from the host SSH key (see .sops.yaml).
        sops = {
          age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
          secrets.wireguard_private_key.sopsFile = secretsFile;
        };

        networking.wireguard.interfaces.wg-home = {
          ips = ["10.86.99.7/32"];
          mtu = 1400;
          privateKeyFile = config.sops.secrets.wireguard_private_key.path;

          peers = [
            {
              publicKey = "58SfszvALRXFx2tLs0hJrCar6aGkPHn9CNIshrYPE00=";
              endpoint = "macopla.com:51820";
              # Split tunnel: only the home/admin ranges; internet traffic stays local.
              allowedIPs = ["10.86.0.0/16"];
              # Keeps the NAT mapping open for inbound admin access.
              persistentKeepalive = 25;
              # macopla.com may change IP.
              dynamicEndpointRefreshSeconds = 60;
            }
          ];
        };

        # NetworkManager (core aspect) must leave the tunnel alone.
        networking.networkmanager.unmanaged = ["interface-name:wg-home"];

        # DNS: home resolvers while the tunnel is healthy, public FallbackDNS otherwise. No global DNS= (resolved
        # would stick to the last server that answered); wg-home-dns sets the home resolvers on wg-home only.
        # TRAP: dns = "none" still pushes DHCP DNS to resolved over D-Bus, so also set systemd-resolved = false.
        services.resolved = {
          enable = true;
          settings.Resolve.FallbackDNS = ["1.1.1.1" "8.8.8.8" "2606:4700:4700::1111" "2001:4860:4860::8888"];
        };
        networking.networkmanager.dns = lib.mkForce "none"; # resolved.nix defaults it to "systemd-resolved"
        networking.networkmanager.settings.main.systemd-resolved = false;

        # The interface stays up when the peer is unreachable, so DNS follows tunnel
        # health (handshake < 180s): healthy -> set DNS on wg-home, unhealthy -> revert.
        systemd.services.wg-home-dns = {
          description = "Route DNS to the home resolvers while wg-home is healthy";
          unitConfig.ConditionPathExists = "/sys/class/net/wg-home";
          serviceConfig.Type = "oneshot";
          script = let
            resolvectl = "${config.systemd.package}/bin/resolvectl";
            wg = "${pkgs.wireguard-tools}/bin/wg";
          in ''
            dev=wg-home
            hs=$(${wg} show "$dev" latest-handshakes | ${pkgs.coreutils}/bin/cut -f2 | ${pkgs.coreutils}/bin/sort -n | ${pkgs.coreutils}/bin/tail -n1)
            now=$(${pkgs.coreutils}/bin/date +%s)
            healthy=0
            if [ "''${hs:-0}" -gt 0 ] && [ $((now - hs)) -lt 180 ]; then healthy=1; fi
            applied=0
            if ${resolvectl} dns "$dev" | ${pkgs.gnugrep}/bin/grep -q 10.86.30.42; then applied=1; fi

            if [ "$healthy" = 1 ] && [ "$applied" = 0 ]; then
              ${resolvectl} dns "$dev" 10.86.30.42 10.86.30.43
              ${resolvectl} domain "$dev" '~.'
              ${resolvectl} default-route "$dev" yes
            elif [ "$healthy" = 0 ] && [ "$applied" = 1 ]; then
              ${resolvectl} revert "$dev"
            fi
          '';
        };
        systemd.timers.wg-home-dns = {
          wantedBy = ["timers.target"];
          timerConfig = {
            OnBootSec = "20s";
            OnUnitActiveSec = "20s";
            AccuracySec = "1s";
          };
        };

        # No inbound UDP port and no checkReversePath change: split tunnel, strict rpfilter passes.

        # The VM has no sops key and no route home.
        virtualisation.vmVariant = {
          networking.wireguard.interfaces = lib.mkForce {};
          sops.secrets = lib.mkForce {};
          services.resolved.enable = lib.mkForce false;
          systemd.timers.wg-home-dns.enable = lib.mkForce false;
          networking.networkmanager.dns = lib.mkOverride 40 "default"; # beats the mkForce "none" above
        };
      })
    ];
  };
}
