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

    nixosModules.audio
    nixosModules.common
    nixosModules.hardware
    nixosModules.hyprland
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
