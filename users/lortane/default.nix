{ outputs, pkgs, ... }:

let
  keys = import ./keys.nix;
in
{
  imports = [
    outputs.nixosModules.normal-users
  ];

  normalUsers = {
    lortane = {
      extraGroups = [
        "openrazer"
        "wheel"
      ];
      sshKeyFiles = keys.keyPaths;
      autoLogin = true;
      enableHyprlock = true;
    };
  };
}
