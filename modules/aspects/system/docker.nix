_: {
  den.aspects.docker = {
    os = _: {
      virtualisation = {
        oci-containers.backend = "podman";
        containers.enable = true;
        docker = {
          rootless = {
            enable = true;
            setSocketVariable = true;
          };
          enableOnBoot = true;
          liveRestore = true;
          storageDriver = "overlay2";
          autoPrune = {
            enable = true;
            dates = "weekly";
          };
          daemon.settings = {
            log-driver = "json-file";
            log-opts = {
              max-size = "10m";
              max-file = "3";
            };
          };
        };
        podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
  };
}
