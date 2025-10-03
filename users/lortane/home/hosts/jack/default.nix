{ ... }:

let
  homeModules = import ../../../../../modules/home;
in
{
  imports = [
    homeModules.desktop
  ];

  desktop.windowManager = "awesome";
  desktop.starship.enable = true;
}
