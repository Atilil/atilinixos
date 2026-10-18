_: {
  den.aspects.home-manager = {
    nixos = {pkgs, ...}: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupCommand = "${pkgs.trashy}/bin/trash";
      };
    };
  };
}
