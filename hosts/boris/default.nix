{
  inputs,
  config,
  nixosModules,
  pkgs,
  ...
}:

{
  imports = [
    ./ddns.nix
    ./hardware.nix
    ./networking.nix
    ./secrets
    ./wireguard.nix

    nixosModules.common
  ]
  ++ (import ../../users/lortane {
    inherit inputs nixosModules pkgs;
    hostHomeModules = [ ];
  });

  _module.args.nixosModules = nixosModules;

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
