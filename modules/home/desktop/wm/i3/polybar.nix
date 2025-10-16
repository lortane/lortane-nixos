{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
  fonts = config.stylix.fonts;
in {
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
      nlSupport = true;
    };

    script = ''
      # Source X11 environment variables
      if [ -f "$HOME/.Xauthority" ]; then
        export XAUTHORITY="$HOME/.Xauthority"
      fi
      export DISPLAY=:0
      polybar main &
    '';

    settings = {
      "settings" = {
        screenchange-reload = true;
        compositing = "background";
        pseudo-transparency = false;
      };

      "bar/main" = {
        # Position
        width = "100%";
        height = "22pt";
        radius = 0;
        fixed-center = true;
        separator = " | ";
        padding-right = 2;

        # Colors
        background = "${colors.base01}";
        foreground = "${colors.base07}";

        # Border
        border-bottom-size = 1;
        border-bottom-color = "${colors.base03}";

        # Use Stylix monospace font
        font-0 = "${fonts.monospace.name}:size=${toString fonts.sizes.terminal};3";
        font-1 = "${fonts.monospace.name}:size=${toString (fonts.sizes.terminal + 2)};3";

        # Modules
        modules-left = "i3";
        modules-center = "date";
        modules-right = "tray cpu volume logout";
      };

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = true;
        enable-click = false;
        enable-scroll = false;

        label-mode = "%mode%";
        label-mode-padding = 1;
        label-mode-background = "${colors.base08}";

        label-focused = "%index%";
        label-focused-background = "${colors.base0D}";
        label-focused-foreground = "${colors.base00}";
        label-focused-padding = 1;

        label-unfocused = "%index%";
        label-unfocused-padding = 1;

        label-visible = "%index%";
        label-visible-background = "${colors.base0B}";
        label-visible-foreground = "${colors.base00}";
        label-visible-padding = 1;

        label-urgent = "%index%";
        label-urgent-background = "${colors.base08}";
        label-urgent-foreground = "${colors.base00}";
        label-urgent-padding = 1;
      };

      "module/tray" = {
        type = "internal/tray";
        format-margin = 8;
        tray-spacing = 8;
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix-foreground = "${colors.base0D}";
        format-underline = "${colors.base0D}";
        label = "%percentage:2%%";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = "${colors.base0B}";
        format-underline = "${colors.base0B}";
        label = "%percentage_used:2%%";
      };

      "module/volume" = {
        type = "internal/pulseaudio";
        use-ui-max = false;
        format-volume = "<ramp-volume> <label-volume>";
        label-muted = "󰖁 %percentage%%";
        label-muted-foreground = "${colors.base03}";

        ramp-volume-0 = "󰕿";
        ramp-volume-1 = "󰖀";
        ramp-volume-2 = "󰕾";
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%Y-%m-%d";
        time = "%H:%M";
        format-prefix-foreground = "${colors.base0D}";
        format-underline = "${colors.base0D}";
        label = "%time% | %date%";
      };

      "module/logout" = {
        type = "custom/text";
        format = "";
        click-left = "i3-msg exit";
      };

      "module/poweroff" = {
        type = "custom/text";
        format = "";
        content-foreground = "${colors.base0D}";
        click-left = "poweroff";
      };
    };
  };
}
