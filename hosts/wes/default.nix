{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix

    outputs.nixosModules.audio
    outputs.nixosModules.common
    outputs.nixosModules.hardware
    outputs.nixosModules.hyprland
  ]
  ++ (import ../../users/lortane {
    inherit inputs outputs pkgs;
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
