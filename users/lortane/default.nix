{ nixosModules, ... }:

{
  imports = [
    nixosModules.normal-users
  ];

  normalUsers.lortane = {
    extraGroups = [ "wheel" ];
    sshKeyFiles = (import ./keys.nix).keyPaths;
  };
}
