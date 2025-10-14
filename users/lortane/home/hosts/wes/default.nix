{...}: let
  homeModules = import ../../../../../modules/home;
in {
  imports = [
    homeModules.desktop
  ];

  desktop = {
    enable = true;
    windowManager = "awesome";
    starship.enable = true;

    appBundles = {
      productivity = true;
      development = true;
      media = true;
    };
  };
}
