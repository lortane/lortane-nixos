{
  lib,
  pkgs,
  config,
  inputs,
  homeModules,
  nixosModules,
  isImage ? false,
  ...
}: {
  imports =
    [
      ./ddns.nix
      ./networking.nix
      ./secrets
      ./wireguard.nix

      nixosModules.bootloader
      nixosModules.common

      (import ../../users/lortane {
        inherit inputs nixosModules pkgs;
      })
    ]
    ++ lib.optionals (!isImage) [./hardware.nix];

  bootloader.systemd.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      KbdInteractiveAuthentication = false;
      MaxAuthtries = 3;
      MaxSessions = 3;
    };
  };
}
