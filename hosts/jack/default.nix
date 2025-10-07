{
  lib,
  pkgs,
  inputs,
  config,
  homeModules,
  nixosModules,
  isImage ? false,
  ...
}:

{
  imports = [
    ./networking.nix
    ./secrets

    nixosModules.bootloader
    nixosModules.desktop
    nixosModules.common
    nixosModules.hardware
    nixosModules.virtualisation

    (import ../../users/lortane {
      inherit inputs nixosModules pkgs;
      extraGroups = [ "openrazer" ];
    })

    (import ../../users/lortane/home-manager.nix {
      inherit inputs homeModules;
      hostHomeModules = [ ../../users/lortane/home/hosts/jack ];
    })
  ]
  ++ lib.optionals (!isImage) [ ./hardware.nix ];

  bootloader.systemd.enable = true;
  services.qemuGuest.enable = true;
  desktop.windowManager = "awesome";

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH
  services.openssh.enable = true;
}
