{
  outputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./ddns.nix
    ./hardware.nix
    ./networking.nix
    ./secrets
    ./wireguard.nix

    outputs.nixosModules.common
  ];

  # User
  users.users.lortane = {
    isNormalUser = true;
    description = "lortane";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUgSiHOxQ6LjMqNqCZuG/ERmYCyNBeX3utA25t6gNbV lortane@wes"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALdHLA/GxlYahccP7wmD1pVnrKaj+deWqWIVBLEknNO loren@zack"
    ];
  };

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

  system.stateVersion = "25.05";
}
