_: {
  den.aspects.hyprland.homeManager = _: {
    wayland.windowManager.hyprland.settings = {
      window_rule = [
        {
          name = "scratch";
          match.class = "^(scratch)$";
          float = true;
          size = "monitor_w*0.5 monitor_h*0.4";
          center = true;
          workspace = "special:scratch silent";
        }
        {
          name = "center-float";
          match.class = "^(center-float)$";
          float = true;
          size = "monitor_w*0.8 monitor_h*0.8";
          center = true;
        }
        {
          name = "thunderbird-ws8";
          match.class = "^(thunderbird)$";
          workspace = "8 silent";
        }
        {
          name = "vesktop-ws9";
          match.class = "^(vesktop)$";
          workspace = "9 silent";
        }
        {
          name = "telegram-ws9";
          match.class = "^(org\\.telegram\\.desktop)$";
          workspace = "9 silent";
        }
        {
          name = "zapzap-ws9";
          match.class = "^(com\\.rtosta\\.zapzap)$";
          workspace = "9 silent";
        }
      ];

      layer_rule = [
        {
          name = "noctalia-regionSelector";
          match.namespace = "^(noctalia:regionSelector)$";
          no_anim = true;
        }
        {
          name = "noctalia";
          match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$";
          ignore_alpha = 0.5;
          blur = true;
          blur_popups = true;
        }
      ];
    };
  };
}
