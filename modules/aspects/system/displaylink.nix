_: {
  den.aspects.displaylink = {
    os = {
      pkgs,
      config,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        displaylink
        wlr-layout-ui
      ];

      boot.kernelModules = ["evdi"];
      boot.extraModulePackages = [config.boot.kernelPackages.evdi];
      services.xserver.videoDrivers = ["displaylink" "modesetting"];
      systemd.services.dlm.wantedBy = ["multi-user.target"];

      # WARNING: do NOT add `powerManagement.resumeCommands` restarting dlm.service: dlm is suspended and ignores
      # SIGTERM, so the upstream S/R handshake (which sends the resume "R") deadlocks and the DisplayLink screens
      # are lost after every resume. The upstream handshake works on its own, leave it alone.

      # Disable USB3 LPM (U1/U2) for the D6000 (17e9:6006): a failed U1 negotiation resets the whole dock
      # (ethernet and DisplayLink). 'k' is USB_QUIRK_NO_LPM; the sysfs usb3_hardware_lpm_u1/u2 knobs are
      # read-only, so a udev rule cannot do this: kernel cmdline only.
      boot.kernelParams = ["usbcore.quirks=17e9:6006:k"];

      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="17e9", ATTR{idProduct}=="6006", ATTR{power/control}="on"
        SUBSYSTEM=="usb", ATTR{idVendor}=="05e3", ATTR{power/control}="on"
        SUBSYSTEM=="usb", ENV{ID_USB_INTERFACES}=="*:03*:*", ATTR{power/control}="on"
      '';
      systemd.services.dock-eth-watchdog = {
        description = "Recover Dell D6000 dock Ethernet from stuck cdc_ncm TX queue";
        wantedBy = ["multi-user.target"];
        after = ["network-pre.target"];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "5s";
          ExecStart = pkgs.writeShellScript "dock-eth-watchdog" ''
            set -u
            JOURNALCTL="${pkgs.systemd}/bin/journalctl"
            DATE="${pkgs.coreutils}/bin/date"

            LAST_ACTION=0

            "$JOURNALCTL" -kf -o cat --no-pager | while IFS= read -r line; do
              case "$line" in
                cdc_ncm*"NETDEV WATCHDOG"*)
                  # Line shape: "cdc_ncm <usb_dev> <iface>: NETDEV WATCHDOG: ..."
                  usb_dev="''${line#cdc_ncm }"
                  usb_dev="''${usb_dev%% *}"
                  [ -n "$usb_dev" ] || continue

                  now="$("$DATE" +%s)"
                  [ $((now - LAST_ACTION)) -ge 15 ] || continue
                  LAST_ACTION="$now"

                  echo "$usb_dev" > /sys/bus/usb/drivers/cdc_ncm/unbind 2>/dev/null || true
                  sleep 2
                  echo "$usb_dev" > /sys/bus/usb/drivers/cdc_ncm/bind 2>/dev/null || true
                  ;;
              esac
            done
          '';
        };
      };
    };
  };
}
