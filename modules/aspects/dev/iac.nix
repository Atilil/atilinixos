_: {
  den.aspects.dev.nixos = _: {
    # TODO: packer http serve rule; drop once the build runs in CI/CD.
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp -s 10.86.30.0/24 --dport 8800:8810 -j nixos-fw-accept
    '';
  };

  den.aspects.dev.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      opentofu
      tflint

      openbao
      drawio
    ];
  };
}
