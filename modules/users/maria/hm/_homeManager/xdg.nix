{lib, ...}: {
  # Beginner user: no Projets/Templates/Public folders cluttering her home.
  xdg.userDirs = {
    projects = lib.mkForce null;
    templates = lib.mkForce null;
    publicShare = lib.mkForce null;
  };
}
