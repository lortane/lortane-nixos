{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;

  enableFor = config: config.desktop.windowManager == "awesome";
in {
  config = mkIf (enableFor config) {
    environment.systemPackages = with pkgs; [
      dbus
      xorg.xorgserver
      xorg.xinit
      xorg.xauth
    ];

    # Create the X session desktop file
    environment.etc."greetd/sessions/awesome.desktop".text = ''
      [Desktop Entry]
      Name=awesome
      Exec=/etc/greetd/awesome-wrapper.sh
      Type=XSession
    '';

    environment.etc."greetd/awesome-wrapper.sh" = {
      text = ''
        #!/bin/sh
        export DISPLAY=:0
        export XAUTHORITY=$HOME/.Xauthority
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

        # Start awesome
        exec ${pkgs.awesome}/bin/awesome
      '';
      mode = "0755";
    };

    services.xserver = {
      enable = true;
      # windowManager.awesome.enable = true;
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
