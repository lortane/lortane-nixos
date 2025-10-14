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
    # Make greetd launch only if graphical target is available
    systemd.services.greetd = {
      enable = true;
      unitConfig = {
        WantedBy = "graphical.target";
        After = "multi-user.target";
      };
    };

    services = {
      xserver.enable = true;
      xserver.displayManager.startx.enable = true;

      greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd startx";
      };
    };
  };
}
