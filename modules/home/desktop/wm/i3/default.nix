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
    programs.rofi.enable = true;
    
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
