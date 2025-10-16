{
  lib,
  pkgs,
  config,
  inputs,
  homeModules,
  nixosModules,
  isImage ? false,
  ...
}: {
  imports =
    [
      ./networking.nix

      nixosModules.bootloader
      nixosModules.common
      nixosModules.desktop
      nixosModules.hardware
      nixosModules.virtualisation

      (import ../../users/lortane {
        inherit inputs nixosModules pkgs;
        extraGroups = ["libvirtd"];
      })

      (import ../../users/lortane/home-manager.nix {
        inherit inputs homeModules;
        hostHomeModules = [../../users/lortane/home/hosts/wes];
      })
    ]
    ++ lib.optionals (!isImage) [./hardware.nix];

  bootloader.systemd.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  virtualisation.qemuHost.enable = true;

  desktop = {
    enable = true;
    windowManager = "i3";
  };

  hardware.intel-gpu.enable = true;
  hardware.razer.enable = true;
}
