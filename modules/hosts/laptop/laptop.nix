{den, ...}: {
  den.aspects.laptop = {
    includes = with den; [
      batteries.hostname
      aspects.sops
      aspects.core
      aspects.security
      aspects.audio
      aspects.bluetooth
      aspects.displaylink
      aspects.fingerprint
      aspects.power
      aspects.docker
      aspects.packages
      aspects.greeter
      aspects.clavier
      aspects.file-manager
      aspects.hyprland
      aspects.plasma
      aspects.gaming
      aspects.shell
    ];

    os = {
      config,
      pkgs,
      ...
    }: {
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
          };
          efi.canTouchEfiVariables = true;
        };

        plymouth.enable = true;
        tmp.cleanOnBoot = true;

        # Hibernate via swapfile, machine-specific
        resumeDevice = "/dev/nvme0n1p2";
        kernelParams = ["resume_offset=19476480"];
      };

      networking.firewall.enable = true;

      services.openssh.enable = false;

      # Plasma for audrey only: no Discover (changes go through the config), no X11 session.
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        discover
        kwin-x11
      ];

      users.mutableUsers = false;
      users.users.root.hashedPasswordFile = config.sops.secrets.root_password.path;
    };
  };
}
