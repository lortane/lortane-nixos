{
  inputs,
  config,
  homeModules,
  nixosModules,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./networking.nix
    # ./secrets

    nixosModules.bootloader
    nixosModules.desktop
    nixosModules.common

    (import ../../users/lortane {
      inherit inputs nixosModules pkgs;
    })

    (import ../../users/lortane/home-manager.nix {
      inherit inputs homeModules;
      hostHomeModules = [ ../../users/lortane/home/hosts/jack ];
    })
  ];

  bootloader.grub.enable = true;

  desktop.windowManager = "awesome";

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH
  services.openssh.enable = true;
}
