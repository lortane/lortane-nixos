{ outputs, ... }:

let
  keys = import ./keys.nix;
in
{
  imports = [
    outputs.nixosModules.normal-users
  ];

  normalUsers = {
    lortane = {
      extraGroups = [ "wheel" ];
      sshKeyFiles = keys.keyPaths;
    };
  };
}
