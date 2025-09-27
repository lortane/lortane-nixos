{  ... }:

let
  homeModules = import ../../../../modules/home;
in
{
  imports = [ homeModules.hyprland ];

  wayland.windowManager.hyprland = {
    enable = true;
    autostart = true;
    settings = {
      bind = [
        "$mod,       s, exec, wezterm -T spotify -e spotify_player"
        "$mod SHIFT, a, exec, chromium --app=https://ai.sid.ovh"
      ];
      windowrule = [
        "workspace 3, title:^spotify$"
      ];
    };
  };
}
