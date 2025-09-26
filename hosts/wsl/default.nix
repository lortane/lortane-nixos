{
  inputs,
  config,
  pkgs,
  ...
}:

let
  nixosModules = import ../../modules/nixos;
in
{
  nixpkgs.hostPlatform = builtins.currentSystem;

  imports = [
    <nixos-wsl/modules>

    ./networking.nix

    nixosModules.common
    nixosModules.virtualisation
  ]
  ++ (import ../../users/lortane { inherit inputs nixosModules pkgs; });

  virtualisation.wsl = {
    enable = true;
    defaultUser = "lortane"; 
  };
}
