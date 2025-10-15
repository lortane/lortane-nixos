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
    environment.etc."greetd/sessions/i3.desktop".text = ''
      [Desktop Entry]
      Name=i3
      Exec=/etc/greetd/i3-wrapper.sh
      Type=XSession
    '';

    environment.etc."greetd/i3-wrapper.sh" = {
      text = ''
        #!/bin/sh
        export DISPLAY=:0
        export XAUTHORITY=$HOME/.Xauthority
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

        # Start i3
        exec ${pkgs.i3}/bin/i3
      '';
      mode = "0755";
    };

    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
      displayManager.lightdm.enable = false;
      displayManager.startx.enable = true;
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
