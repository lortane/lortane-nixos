{
  inputs,
  config,
  nixosModules,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./networking.nix

    nixosModules.desktop
    nixosModules.common
    nixosModules.hardware
    nixosModules.virtualisation
  ]
  ++ (import ../../users/lortane {
    inherit inputs nixosModules pkgs;
    hostHomeModules = [ ../../users/lortane/home/hosts/jack ];
  });

  services.qemuGuest.enable = true;
  hardware.razer.enable = true;
  desktop.windowManager = "awesome";

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH
  services.openssh.enable = true;
}
