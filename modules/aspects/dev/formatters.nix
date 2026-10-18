_: {
  den.aspects.dev.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra # nix
      shfmt # shell
      black # python
      taplo # toml
      yamllint # yaml
    ];
  };
}
