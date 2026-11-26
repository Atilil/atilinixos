_: {
  den.aspects.office.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspellDicts.fr-moderne
      hyphenDicts.fr_FR
    ];
  };
}
