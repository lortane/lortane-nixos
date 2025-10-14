{
  config,
  homeModules,
  ...
}: let
  homeModules = import ../../../../../modules/home;
in {
  imports = [
    ./git.nix
    ./home.nix

    homeModules.common
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
