{lib, ...}: let
  vagrantEnable = false;
in {
  den.aspects.dev = {
    nixos = {pkgs, ...}: {
      virtualisation.virtualbox.host = {
        enable = false;
        package = pkgs.virtualbox;
      };
    };

    homeManager = {pkgs, ...}: {
      home.packages = lib.optional vagrantEnable pkgs.vagrant;
    };
  };
}
