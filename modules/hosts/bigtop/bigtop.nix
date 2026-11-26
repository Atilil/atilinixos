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

    os = {
      config,
      pkgs,
      ...
    }: let
      hdaFw = pkgs.writeText "hda-jack-retask.fw" ''
        [codec]
        0x10ec0897 0x1458a194 0

        [pincfg]
        0x1a 0x01014010
      '';
      hdaFwPkg = pkgs.runCommand "hda-jack-retask-fw" {} ''
        install -Dm644 ${hdaFw} $out/lib/firmware/hda-jack-retask.fw
      '';
    in {
      imports = [
        ./_hardware.nix
      ];

      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            editor = false;
            memtest86.enable = true;
            configurationLimit = 5;
            extraInstallCommands = ''
              sed -i 's|^default .*|default auto-windows|' /boot/loader/loader.conf
            '';
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };
        tmp.cleanOnBoot = true;
        initrd.kernelModules = ["i915"];
        extraModprobeConfig = "options snd-hda-intel patch=hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw";
      };
      networking.firewall.enable = true;
      services.openssh.enable = false;
      services.xserver.videoDrivers = ["nvidia"];
      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;
          open = true;
        };
        firmware = [hdaFwPkg];
      };
      sops.secrets.nas_ext_smb_credentials = {};
      users.mutableUsers = false;
      users.users.root.hashedPasswordFile = config.sops.secrets.root_password.path;
    };
  };
}
