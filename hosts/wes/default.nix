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
  imports = [
    ./hardware.nix
    ./networking.nix

    nixosModules.desktop
    nixosModules.common
    nixosModules.hardware
  ]
  ++ (import ../../users/lortane {
    inherit inputs nixosModules pkgs;
    hostModules = [ ../../users/lortane/home/hosts/wes ];
  });

  powerManagement.cpuFreqGovernor = "performance";

  desktop.windowManager = "awesome";

  hardware.intel-gpu.enable = true;
  hardware.razer.enable = true;
}
