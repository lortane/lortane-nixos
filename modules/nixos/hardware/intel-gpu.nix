{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.hardware.intel-gpu.enable = mkEnableOption "Intel GPU harware support";

  config = mkIf config.hardware.intel-gpu.enable {
    services.xserver.videoDrivers = mkDefault [ "modesetting" ];
    boot.initrd.kernelModules = [ "xe" ];
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    hardware = {
      enableRedistributableFirmware = mkDefault true;
      graphics = {
        enable = mkDefault true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
        ];
      };
    };
  };
}
