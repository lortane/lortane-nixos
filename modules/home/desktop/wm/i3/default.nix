{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.desktop;
in {
  imports = [
    ./polybar.nix
  ];

  config = lib.mkIf (cfg.enable && cfg.windowManager == "i3") {
    xsession.windowManager.i3 = {
      enable = true;

      config = rec {
        modifier = "Mod4";

        terminal = "wezterm";
        menu = "${pkgs.rofi}/bin/rofi -modi drun -show drun";
        bars = [];

        window.border = 0;

        gaps = {
          inner = 15;
          outer = 5;
        };

        # Default workspace output
        workspaceOutputAssign = [
          {
            output = "primary";
            workspace = "1";
          }
        ];

        focus.followMouse = false;

        keybindings = lib.mkOptionDefault {
          "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
          "${modifier}+q" = "kill";

          # Vim-like focus
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Vim-like window movement
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Reload and restart i3
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";

          # Window management
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # Workspaces
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";

          # Move containers to workspaces
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
        };

        startup = [
          # {
          #   command = "exec i3-msg workspace 1";
          #   always = true;
          #   notification = false;
          # }
          {
            command = "systemctl --user restart polybar.service";
            always = true;
            notification = false;
          }
          # {
          #   command = "${pkgs.feh}/bin/feh --bg-scale ~/background.png";
          #   always = true;
          #   notification = false;
          # }
        ];
      };
    };
  };
}
