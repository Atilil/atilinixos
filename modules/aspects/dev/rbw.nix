_: {
  den.aspects.dev.homeManager = {
    pkgs,
    lib,
    config,
    ...
  }: let
    # Answers rbw's pinentry from gnome-keyring (unlocked by PAM at login);
    # falls back to pinentry-qt once to store the master password.
    # Not shipped by the nixpkgs rbw package.
    rbwPinentryKeyring =
      pkgs.runCommand "rbw-pinentry-keyring" {
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/doy/rbw/303e7a2e28ecafee8fd157c3ee86a7f1e668033c/bin/rbw-pinentry-keyring";
          hash = "sha256-DoIapbUy+YbKvtERTMZZ43wOXT0QYPTFO8CxeywWH84=";
        };
        nativeBuildInputs = [pkgs.makeWrapper];
        meta.mainProgram = "rbw-pinentry-keyring";
      } ''
        install -Dm755 $src $out/bin/rbw-pinentry-keyring
        substituteInPlace $out/bin/rbw-pinentry-keyring \
          --replace-fail '#!/bin/bash' '#!${pkgs.runtimeShell}'
        wrapProgram $out/bin/rbw-pinentry-keyring \
          --prefix PATH : ${lib.makeBinPath [pkgs.libsecret pkgs.pinentry-qt]}
      '';
  in {
    programs.rbw = {
      enable = true;
      settings = {
        email = config.userInfo.emails.admin;
        base_url = "https://vault.macopla.com/";
        pinentry = rbwPinentryKeyring;
        lock_timeout = 86400;
      };
    };
  };
}
