{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;

  enableFor = config: config.desktop.windowManager == "i3";
in {
  config = mkIf (enableFor config) {
    environment.systemPackages = with pkgs; [
      tuigreet
      dbus
      xorg.xorgserver
      xorg.xinit
      xorg.xauth
    ];

    environment.etc."greetd/sessions/i3-x11.sh".text = ''
      #!/bin/sh

      export XDG_SESSION_TYPE=x11

      # ensure we run i3 under a per-session DBus (notifications, systemd user units, etc.)
      dbus-run-session xfce+i3
    '';

    environment.etc."greetd/sessions/i3.desktop".text = ''
      [Desktop Entry]
      Name=i3 (X11)
      Exec=/etc/greetd/sessions/i3-x11.sh
      Type=Application
      NoTerminal=true
    '';

    services.xserver = {
      enable = true;   
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3.enable = true;
      displayManager.lightdm.enable = false;
    };
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --sessions /etc/greetd/sessions";
    };

    # services.displayManager.defaultSession = "xfce+i3";
  };
}
