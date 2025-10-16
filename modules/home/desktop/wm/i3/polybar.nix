{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.desktop;
in {
  config = lib.mkIf (cfg.enable && cfg.windowManager == "i3") {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        pulseSupport = true;
        nlSupport = true;
      };

      config = {
        "global/wm" = {
          margin-top = 0;
          margin-bottom = 0;
        };

        "bar/main" = {
          width = "100%";
          height = 24;
          offset-x = 0;
          offset-y = 0;
          background = "#2E3440";
          foreground = "#D8DEE9";
          line-size = 2;
          padding-right = 2;
          module-margin = 1;
          # font-0 = "DejaVu Sans Mono:size=10;1";
          # font-1 = "FontAwesome:size=10;1";
          # modules-left = "i3";
          modules-center = "";
          modules-right = "cpu memory date";
        };

        # "module/i3" = {
        #   type = "internal/i3";
        #   format = "<label-state> <label-mode>";
        #   index-sort = true;
        #   wrapping-scroll = false;

        #   label-mode-padding = 2;
        #   label-mode-foreground = "#000";
        #   label-mode-background = "#FFB52A";

        #   label-focused = "%index%";
        #   label-focused-background = "#81A1C1";
        #   label-focused-foreground = "#2E3440";
        #   label-focused-padding = 2;

        #   label-unfocused = "%index%";
        #   label-unfocused-padding = 2;
        #   label-unfocused-foreground = "#D8DEE9";

        #   label-visible = "%index%";
        #   label-visible-background = "\${self.label-focused-background}";
        #   label-visible-foreground = "\${self.label-focused-foreground}";
        #   label-visible-padding = "\${self.label-focused-padding}";

        #   label-urgent = "%index%";
        #   label-urgent-background = "#BF616A";
        #   label-urgent-foreground = "#2E3440";
        #   label-urgent-padding = 2;
        # };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = "CPU ";
          format-prefix-foreground = "#81A1C1";
          format = "<label>";
          label = "%percentage:2%%";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = "RAM ";
          format-prefix-foreground = "#81A1C1";
          format = "<label>";
          label = "%percentage_used:2%%";
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;
          date = "%a %b %d";
          time = "%H:%M";
          format = "<label>";
          label = "%date% %time%";
        };
      };

      # Polybar script
      script = ''
        # Terminate already running bar instances
        killall -q polybar

        # Wait until the processes have been shut down
        while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

        # Launch Polybar
        polybar main &
      '';
    };
  };
}
