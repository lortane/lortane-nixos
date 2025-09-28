{ ... }:

let
  homeModules = import ../../../../../modules/home;
in
{
  imports = [
    homeModules.awesomewm
  ];
}
