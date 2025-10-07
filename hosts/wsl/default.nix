{
  pkgs,
  inputs,
  config,
  nixosModules,
  homeModules,
  ...
}:

{
  imports = [
    ./networking.nix

    nixosModules.common
    nixosModules.virtualisation

    (import ../../users/lortane {
      inherit inputs nixosModules pkgs;
    })

    (import ../../users/lortane/home-manager.nix {
      inherit inputs homeModules;
    })
  ];

  virtualisation.wsl = {
    enable = true;
    defaultUser = "lortane";
  };
}
