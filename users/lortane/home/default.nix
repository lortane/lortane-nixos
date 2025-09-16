{ outputs, ... }:

{
  imports = [
    ./git.nix
    ./home.nix
    #    ./nix.nix
    #    ./nixvim.nix
    #    ./secrets

    outputs.homeModules.common
  ];
}
