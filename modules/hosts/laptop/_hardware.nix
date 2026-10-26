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

  services.libinput.enable = true;
}
