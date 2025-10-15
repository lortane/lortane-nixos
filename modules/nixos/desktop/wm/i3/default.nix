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
      Exec=${pkgs.i3}/bin/i3
      Type=XSession
    '';

    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
      displayManager.lightdm.enable = false;
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
