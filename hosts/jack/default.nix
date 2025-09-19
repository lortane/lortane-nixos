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
  ];

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
