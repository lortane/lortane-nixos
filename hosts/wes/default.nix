{
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

    ../../users/lortane

    outputs.nixosModules.audio
    outputs.nixosModules.common
    outputs.nixosModules.hyprland
  ];

  powerManagement.cpuFreqGovernor = "performance";
}
