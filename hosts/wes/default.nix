{
  lib,
  pkgs,
  config,
  inputs,
  homeModules,
  nixosModules,
  isImage ? false,
  ...
}:

{
  imports = [
    ./networking.nix

    nixosModules.bootloader
    nixosModules.desktop
    nixosModules.common
    nixosModules.hardware

    (import ../../users/lortane {
      inherit inputs nixosModules pkgs;
    })

    (import ../../users/lortane/home-manager.nix {
      inherit inputs homeModules;
      hostHomeModules = [ ../../users/lortane/home/hosts/wes ];
    })
  ]
  ++ lib.optionals (!isImage) [ ./hardware.nix ];

  bootloader.systemd.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  desktop.windowManager = "awesome";

  hardware.intel-gpu.enable = true;
  hardware.razer.enable = true;
}
