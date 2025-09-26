{
  nixosModules,
  config,
  pkgs,
  ...
}:

{
  imports = [
    <nixos-wsl/modules>
    ./boot.nix
    ./networking.nix
    ./peripherals.nix

    nixosModules.audio
    nixosModules.common
  ]
  ++ (import ../../users/lortane { });

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  environment.systemPackages = [
    pkgs.wget
  ];

  programs.nix-ld.enable = true;

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
