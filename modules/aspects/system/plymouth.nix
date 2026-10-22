# Boot splash + silent boot. The GPU driver for early KMS is hardware-specific:
# each host adds it to boot.initrd.kernelModules, or the simpledrm → GPU driver
# handoff interrupts the splash.
_: {
  den.aspects.plymouth = {
    os = {pkgs, ...}: {
      boot = {
        plymouth = {
          enable = true;
          theme = "rings";
          themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["rings"];})];
        };

        # Otherwise kernel/systemd messages show over the splash
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];
      };
    };
  };
}
