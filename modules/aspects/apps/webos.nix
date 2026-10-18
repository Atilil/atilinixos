_: {
  den.aspects.webos.homeManager = {pkgs, ...}: let
    version = "1.99.16";
    src = pkgs.fetchurl {
      url = "https://github.com/webosbrew/dev-manager-desktop/releases/download/v${version}/webos-dev-manager_${version}_amd64.AppImage";
      hash = "sha256-1Eg8flL81vJXcGG9492tePqI4LpvEap2spuYtfIwAKU=";
    };
    appimageContents = pkgs.appimageTools.extract {
      pname = "webos-dev-manager";
      inherit version src;
    };
    webos-dev-manager = pkgs.appimageTools.wrapType2 {
      pname = "webos-dev-manager";
      inherit version src;
      extraInstallCommands = ''
        install -Dm644 ${appimageContents}/webos-dev-manager.desktop \
          $out/share/applications/webos-dev-manager.desktop
        cp -r ${appimageContents}/usr/share/icons $out/share/
      '';
    };
  in {
    home.packages = [webos-dev-manager];
  };
}
