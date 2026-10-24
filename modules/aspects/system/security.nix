_: {
  den.aspects.security = {
    os = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [libsecret sops age];

      security = {
        polkit.enable = true;
        pam.services.login.enableGnomeKeyring = true;
        sudo.wheelNeedsPassword = false;
        pki.certificateFiles = [./_certs/pve-root-ca.crt]; # homelab proxmox cluster certificates
      };

      programs.seahorse.enable = true;
      services.gnome.gnome-keyring.enable = true;
    };
  };
}
