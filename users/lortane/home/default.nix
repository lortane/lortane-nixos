{
  lib,
  config,
  homeModules,
  ...
}: let
  homeModules = import (lib.custom.relativeToRoot "modules/home");
in {
  imports = [
    ./git.nix
    ./home.nix

    homeModules.common
  ];
}
