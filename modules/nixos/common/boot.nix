{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ../virtualisation ];

  boot.loader = lib.mkIf (!config.virtualisation.wsl.enable) {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
