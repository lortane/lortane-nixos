{ config, homeModules, ... }:

{
  imports = [
    ./git.nix
    ./home.nix

    homeModules.common
  ];
}
