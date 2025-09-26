{ config, ... }:

let
  homeModules = import ../../../modules/home;
in
{
  imports = [
    ./git.nix
    ./home.nix

    homeModules.common
  ];

}
