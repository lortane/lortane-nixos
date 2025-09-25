{ config, pkgs, lib, ... }:

{
  # Define an option to enable this user-level hardware module
  options.home.hardware.razer.enable = lib.mkEnableOption "Razer hardware user configuration";

  # Configure the user if the option is enabled
  config = lib.mkIf config.home.hardware.razer.enable {
    # Add the user to the "openrazer" group
    users.extraGroups = [ "openrazer" ];
  };
}