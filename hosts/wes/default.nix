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

    nixosModules.audio
    nixosModules.common
    nixosModules.hardware
    nixosModules.hyprland
  ]
  ++ (import ../../users/lortane {
    inherit inputs nixosModules pkgs;
    hostModules = [ ../../users/lortane/home/hosts/wes ];
  });

  powerManagement.cpuFreqGovernor = "performance";

  services.xserver.videoDrivers = [ "modesetting" ];
  # boot.initrd.kernelModules = [ "xe" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };
}
