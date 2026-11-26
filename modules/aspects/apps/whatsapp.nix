_: {
  den.aspects.whatsapp.homeManager = {
    lib,
    pkgs,
    ...
  }: {
    programs.zapzap.enable = true;

    # ZapZap rewrites its own .conf: set only these keys on each switch instead of owning the file
    home.activation.zapzapSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      f="$HOME/.config/ZapZap/ZapZap.conf"
      run mkdir -p "$(dirname "$f")"
      for kv in "notification donation_message false" "system wayland true" "website open_page false"; do
        set -- $kv
        run ${pkgs.crudini}/bin/crudini --set "$f" "$1" "$2" "$3"
      done
    '';
  };
}
