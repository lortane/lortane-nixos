{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.desktop;
in {
  config = lib.mkIf (cfg.enable && cfg.windowManager == "awesome") {
    # Enable the awesome WM module (this handles startup and package)
    xsession.enable = true;
    xsession.windowManager.awesome = {
      enable = true;
    };

    programs.rofi.enable = true;
    #services.picom.enable = true;

    xdg.configFile."awesome" = {
      source = ./awesome;
      recursive = true;
    };

    home.packages = with pkgs; [
      feh
      imagemagick
    ];
  };
}
