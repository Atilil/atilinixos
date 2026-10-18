{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "ahci" "nvme" "usb_storage" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  #INFO: Intel GPU — hardware video acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [intel-media-driver];
  };
  #INFO: Enable GuC/HuC firmware for better GPU scheduling and power management
  boot.extraModprobeConfig = "options i915 enable_guc=2";

  #INFO: Stable DRM device path for Hyprland — avoids /dev/dri/cardX index shifting on reboot
  system.activationScripts.hyprCardSymlink = ''
    ln -sf /dev/dri/by-path/pci-0000:00:02.0-card /run/hyprland-card
  '';
  environment.sessionVariables.WLR_DRM_DEVICES = "/run/hyprland-card";

  services.libinput.enable = true;
}
