{
  lib,
  pkgs,
  inputs,
  config,
  homeModules,
  nixosModules,
  isImage ? false,
  ...
}: {
  imports =
    [
      ./networking.nix
      # ./secrets

      nixosModules.bootloader
      nixosModules.common
      nixosModules.desktop

      (import ../../users/lortane {
        inherit inputs nixosModules pkgs;
      })

      (import ../../users/lortane/home-manager.nix {
        inherit inputs homeModules;
        hostHomeModules = [../../users/lortane/home/hosts/jack];
      })
    ]
    ++ lib.optionals (!isImage) [./hardware.nix];

  bootloader.systemd.enable = true;
  virtualisation.vmware.guest.enable = true;

  desktop = {
    enable = true;
    windowManager = "awesome";
  };

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH
  services.openssh.enable = true;
}
