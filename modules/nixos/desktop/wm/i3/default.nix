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
      dbus
      xorg.xorgserver
      xorg.xinit
      xorg.xauth
    ];

    # Create the X session desktop file
    environment.etc."greetd/sessions/xfce-i3.desktop".text = ''
      [Desktop Entry]
      Name=XFCE+i3
      Exec=dbus-run-session xfce4-session
      Type=XSession
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

    # This tells XFCE to use i3 as the window manager
    environment.sessionVariables = {
      XFCE4_SESSION_WM = "${pkgs.i3}/bin/i3";
    };

    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --xsessions /etc/greetd/sessions";
    };

    systemd.services.greetd = {
      enable = true;
      unitConfig = {
        WantedBy = "graphical.target";
        After = "multi-user.target";
      };
    };
  };
}
