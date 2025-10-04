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
    nixosModules.virtualisation
  ]
  ++ (import ../../users/lortane {
    inherit inputs nixosModules pkgs;
    hostHomeModules = [ ../../users/lortane/home/hosts/jack ];
  });

  virtualisation.vmware.guest.enable = true;
  #virtualisation.qemuHost.enable = true; disable for now since tkinter dependency is broken
  hardware.razer.enable = true;
  desktop.windowManager = "awesome";

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH
  services.openssh.enable = true;
}
