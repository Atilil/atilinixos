_: {
  den.aspects.office.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Qt build of LibreOffice (native Plasma look); dictionaries come from the two packages below.
      libreoffice-qt
      hunspellDicts.fr-moderne
      hyphenDicts.fr_FR
    ];
  };
}
