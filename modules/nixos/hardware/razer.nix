{ config, pkgs, lib, ... }:

{
  # Define an option to enable this hardware module
  options.hardware.razer.enable = lib.mkEnableOption "Razer hardware support";

  # Configure the system if the option is enabled
  config = lib.mkIf config.hardware.razer.enable {
    # Install the openrazer packages
    environment.systemPackages = with pkgs; [
      openrazer-daemon
    ];

    # Enable the openrazer service
    services.openrazer.enable = true;

    # Add the "openrazer" group to the system
    users.groups.openrazer = {};
  };
}