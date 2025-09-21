{ outputs, ... }:

{
  imports = [
    ./git.nix
    ./home.nix
    ./nixvim.nix

    outputs.homeModules.common
    outputs.homeModules.starship
  ];
}
