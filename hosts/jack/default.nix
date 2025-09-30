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
    ./boot.nix
    ./hardware.nix
    ./networking.nix

    nixosModules.common
    nixosModules.hardware
    nixosModules.xmonad
  ]
  ++ (import ../../users/lortane {
    inherit inputs nixosModules pkgs;
    hostHomeModules = [ ../../users/lortane/home/hosts/jack ];
  });

  virtualisation.vmware.guest.enable = true;

  hardware.razer.enable = true;

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH
  services.openssh.enable = true;
}
