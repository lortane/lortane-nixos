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
      # Global settings
      "settings" = {
        screenchange-reload = true;
        compositing = "background";
        pseudo-transparency = false;
      };

      "bar/main" = {
        # Position
        width = "100%";
        height = "23pt";
        radius = 0;
        fixed-center = true;

        # Colors
        background = "${colors.base00}";
        foreground = "${colors.base07}";

        # Use Stylix monospace font
        font-0 = "${fonts.monospace.name}:size=${toString fonts.sizes.terminal};3";
        font-1 = "${fonts.monospace.name}:size=${toString (fonts.sizes.terminal + 2)};3";

        # Modules
        modules-left = "i3";
        modules-center = "";
        modules-right = "cpu memory volume date";

        # Tray
        tray-position = "right";
        tray-padding = 2;
      };

      # i3 workspace module
      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = true;
        wrapping-scroll = false;
        pin-workspaces = true;
        strip-wsnumbers = true;

        label-mode-padding = 2;
        label-mode-background = "${colors.base08}";

        label-focused = "%icon%";
        label-focused-background = "${colors.base0D}";
        label-focused-foreground = "${colors.base00}";
        label-focused-padding = 2;

        label-unfocused = "%icon%";
        label-unfocused-padding = 2;

        label-visible = "%icon%";
        label-visible-background = "${colors.base0B}";
        label-visible-foreground = "${colors.base00}";
        label-visible-padding = 2;

        label-urgent = "%icon%";
        label-urgent-background = "${colors.base08}";
        label-urgent-foreground = "${colors.base00}";
        label-urgent-padding = 2;
      };

      # CPU module
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = "${colors.base0D}";
        format-underline = "${colors.base0D}";
        label = "%percentage:2%%";
      };

      # Memory module
      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = "${colors.base0B}";
        format-underline = "${colors.base0B}";
        label = "%percentage_used:2%%";
      };

      # Volume module
      "module/volume" = {
        type = "internal/pulseaudio";
        use-ui-max = false;
        format-volume = "<ramp-volume> <label-volume>";
        label-muted = "󰖁 muted";
        label-muted-foreground = "${colors.base03}";

        ramp-volume-0 = "󰕿";
        ramp-volume-1 = "󰖀";
        ramp-volume-2 = "󰕾";

        click-right = "pavucontrol";
      };

      # Date module
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%Y-%m-%d";
        time = "%H:%M";
        format-prefix = "󰃭 ";
        format-prefix-foreground = "${colors.base0D}";
        format-underline = "${colors.base0D}";
        label = "%time% %date%";
      };
    };
  };

  home.packages = with pkgs; [pavucontrol];
}
