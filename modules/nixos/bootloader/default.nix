{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkDefault
    mkOption
    mkIf
    types
    ;
in {
  options.bootloader = {
    systemd.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable systemd-boot as the bootloader (for EFI systems).";
    };

    grub = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable GRUB as the bootloader.";
      };

      device = mkOption {
        type = types.str;
        default = "nodev";
        description = "Device to install GRUB on (e.g. /dev/sda or nodev for EFI).";
      };
    };
  };

  config = lib.mkMerge [
    (mkIf config.bootloader.systemd.enable {
      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.configurationLimit = 10;
      boot.loader.efi.canTouchEfiVariables = true;
    })

    (mkIf config.bootloader.grub.enable {
      boot.loader.grub.enable = true;
      boot.loader.grub.device = config.bootloader.grub.device;
      boot.loader.grub.efiSupport = mkDefault true;
      boot.loader.grub.efiInstallAsRemovable = mkDefault true;
    })
  ];
}
