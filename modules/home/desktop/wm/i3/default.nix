{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.desktop;
  colors = config.lib.stylix.colors.withHashtag;

  lockScript = pkgs.writeShellScriptBin "enhanced-lock" ''
    ${pkgs.i3lock-color}/bin/i3lock \
      --color="${colors.base00}" \
      --inside-color="${colors.base01}90" \
      --ring-color="${colors.base0D}" \
      --keyhl-color="${colors.base0B}" \
      --bshl-color="${colors.base08}" \
      --separator-color="${colors.base02}" \
      --insidever-color="${colors.base00}" \
      --ringver-color="${colors.base0B}" \
      --verif-color="${colors.base0B}" \
      --insidewrong-color="${colors.base00}" \
      --ringwrong-color="${colors.base08}" \
      --wrong-color="${colors.base08}" \
      --time-str="%H:%M" \
      --date-str="%Y-%m-%d" \
      --time-color="${colors.base07}" \
      --date-color="${colors.base07}" \
      --layout-color="${colors.base07}" \
      --clock \
      --time-size=24 \
      --date-size=14 \
      --time-font="${config.stylix.fonts.monospace.name}" \
      --date-font="${config.stylix.fonts.monospace.name}" \
      --verif-text="Verifying..." \
      --wrong-text="Access Denied" \
      --noinput="Enter Password" \
      --lock-text="Locking..." \
      --lockfailed="Lock Failed" \
      --show-failed-attempts \
      --ignore-empty-password \
      --radius=120 \
      --ring-width=8.0 \
      --indicator \
      --nofork
  '';
in {
  imports = [
    ./polybar.nix
  ];

  config = lib.mkIf (cfg.enable && cfg.windowManager == "i3") {
    programs.rofi.enable = true;
    home.packages = with pkgs; [
      i3lock-color
      lockScript
    ];

    xsession.windowManager.i3 = {
      enable = true;

      config = rec {
        modifier = "Mod4";

        terminal = "wezterm";
        menu = "${pkgs.rofi}/bin/rofi -modi drun -show drun";

        bars = [];

        window = {
          border = 1;
          titlebar = false;
        };

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
          "${modifier}+g" = "splith";

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

          # i3lock
          "${modifier}+Escape" = "exec enhanced-lock";
        };

        startup = [
          {
            command = "exec i3-msg workspace 1";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user restart polybar.service";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.xorg.xsetroot}/bin/xsetroot -solid '${colors.base00}'";
            always = true;
            notification = false;
          }
        ];
      };
    };
  };
}
