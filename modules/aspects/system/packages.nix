_: {
  den.aspects.packages = {
    os = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        nmap
        wget
        curl
        jq
        dig
        unzip
        rsync
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.hack
        inter
        noto-fonts-lgc-plus
        noto-fonts-color-emoji
        liberation_ttf
      ];
    };
  };
}
