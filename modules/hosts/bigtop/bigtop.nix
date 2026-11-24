{den, ...}: {
  den.aspects.bigtop = {
    includes = with den; [
      batteries.hostname
      aspects.sops
      aspects.core
      aspects.security
      aspects.audio
      aspects.bluetooth
      aspects.power
      aspects.docker
      aspects.packages
      aspects.greeter
      aspects.clavier
      aspects.file-manager
      aspects.hyprland
      aspects.gaming
      aspects.shell
    ];

    os = {config, ...}: {
      imports = [
        ./_hardware.nix
        ./_file-system.nix
      ];

      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            editor = false;
            memtest86.enable = true;
            configurationLimit = 5;
            extraEntries."windows.conf" = ''
              title Windows
              windows /EFI/Microsoft/Boot/bootmgfw.efi
            '';
            extraInstallCommands = ''
              echo "default windows.con" >> /boot/loader/loader.conf
            '';
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };
        tmp.cleanOnBoot = true;
        initrd.kernelModules = ["i915"];
      };
      networking.firewall.enable = true;
      services.openssh.enable = false;
      sops.secrets.nas_ext_smb_credentials = {};
      users.mutableUsers = false;
      users.users.root.hashedPasswordFile = config.sops.secrets.root_password.path;
    };
  };
}
