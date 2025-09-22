[
  "$mod,       KP_Insert,      workspace, 1" # go to workspace 1
  "$mod,       KP_End,      workspace, 2" # ...
  "$mod,       KP_Down,      workspace, 3"
  "$mod,       KP_Next,      workspace, 4"

  # switch focus
  "$mod,       left, movefocus, l"
  "$mod,       h, movefocus, l"
  "$mod,       right, movefocus, r"
  "$mod,       l, movefocus, r"
  "$mod,       up, movefocus, u"
  "$mod,       k, movefocus, u"
  "$mod,       down, movefocus, d"
  "$mod,       j, movefocus, d"

  # switch workspace
  "$mod SHIFT, KP_Insert,  exec, hyprctl dispath workspace 5"
  "$mod SHIFT, KP_End,     exec, hyprctl dispath workspace 6"
  "$mod SHIFT, KP_Down,    exec, hyprctl dispath workspace 7"
  "$mod SHIFT, KP_Next,    exec, hyprctl dispath workspace 8"

  "$mod SHIFT, KP_Insert,  movetoworkspace, 1"
  "$mod SHIFT, KP_End,     movetoworkspace, 2"
  "$mod SHIFT, KP_Down,    movetoworkspace, 3"
  "$mod SHIFT, KP_Next,    movetoworkspace, 4"

  # window control
  "$mod SHIFT, left,       movewindow, l"
  "$mod SHIFT, h,          movewindow, l"
  "$mod SHIFT, right,      movewindow, r"
  "$mod SHIFT, l,          movewindow, r"
  "$mod SHIFT, up,         movewindow, u"
  "$mod SHIFT, k,          movewindow, u"
  "$mod SHIFT, down,       movewindow, d"
  "$mod SHIFT, j,          movewindow, d"
  "$mod CTRL,  left,       resizeactive, -80 0"
  "$mod CTRL,  right,      resizeactive, 80 0"
  "$mod CTRL,  up,         resizeactive, 0 -80"
  "$mod CTRL,  down,       resizeactive, 0 80"
  "$mod ALT,   left,       moveactive,  -80 0"
  "$mod ALT,   right,      moveactive, 80 0"
  "$mod ALT,   up,         moveactive, 0 -80"
  "$mod ALT,   down,       moveactive, 0 80"
]
