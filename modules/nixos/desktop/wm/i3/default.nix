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
      displayManager.lightdm = {
        enable = true;
        greeters.gtk
    
      };
    };
    services.displayManager.defaultSession = "xfce+i3";
  };
}
