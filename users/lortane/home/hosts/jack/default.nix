{lib, ...}: let
  homeModules = import (lib.custom.relativeToRoot "modules/home");
in {
  imports = [
    homeModules.desktop
  ];

  desktop = {
    enable = true;
    windowManager = "i3";
    starship.enable = true;

    appBundles = {
      productivity = true;
      development = true;
      media = true;
    };
  };
}
