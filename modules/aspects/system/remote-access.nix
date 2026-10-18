{config, ...}: let
  adminSshKey = config.flake.lib.adminSshKey;
in {
  # Remote admin and assistance (SSH + RDP) for the ideapad; the laptop keeps openssh off.
  den.aspects.remote-access.os = {
    config,
    lib,
    ...
  }: let
    # Without the vpn aspect's interface (VM), ports stay open everywhere.
    onVpn = config.networking.wireguard.interfaces ? wg-home;
    ports = [22 3389];
    adminNet = "10.86.0.0/16";
  in {
    # Key-only, for `nixos-rebuild --target-host root@<host>`.
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    # Admin key on root only.
    users.users.root.openssh.authorizedKeys.keys = [adminSshKey];

    # KRdp (RDP on the live session): its unit is preset-disabled, so start it with Plasma.
    # Per-user settings: the homeManager side below.
    systemd.user.services."app-org.kde.krdpserver" = {
      overrideStrategy = "asDropin";
      wantedBy = ["plasma-workspace.target"];
    };

    # SSH/RDP only from the admin network, on any interface (admin LAN or tunnel).
    # Open to all without the VPN (VM, QEMU hostfwd).
    networking.firewall =
      if onVpn
      then {
        extraCommands = ''
          iptables -A nixos-fw -p tcp -s ${adminNet} -m multiport --dports ${lib.concatMapStringsSep "," toString ports} -j nixos-fw-accept
        '';
      }
      else {allowedTCPPorts = ports;};
  };

  # Per-user KRdp config; users include this aspect to get it.
  den.aspects.remote-access.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    # KRdp per-user config (service: above). SystemUserEnabled logs in with the Linux
    # account: a KRdp-specific password would live in KWallet, not in Nix.
    programs.plasma.configFile."krdpserverrc".General = {
      Autostart = true;
      ListenPort = 3389;
      SystemUserEnabled = true;
      # Required to start; seeded by home.activation.krdpCertificate.
      Certificate = "/home/maria/.local/share/krdp/krdp.crt";
      CertificateKey = "/home/maria/.local/share/krdp/krdp.key";
    };

    # Self-signed TLS cert for KRdp, created once so the RDP fingerprint stays stable.
    home.activation.krdpCertificate = lib.hm.dag.entryAfter ["writeBoundary"] ''
      dir="$HOME/.local/share/krdp"
      if [ ! -s "$dir/krdp.crt" ] || [ ! -s "$dir/krdp.key" ]; then
        run mkdir -p "$dir"
        run ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
          -subj "/CN=ideapad" -keyout "$dir/krdp.key" -out "$dir/krdp.crt"
        run chmod 600 "$dir/krdp.key"
      fi
    '';
  };
}
