{
  nixosModules,
  extraGroups ? [ ],
  ...
}:

{
  imports = [
    nixosModules.normal-users
  ];

  normalUsers.lortane = {
    extraGroups = [ "wheel" ] ++ extraGroups;
    sshKeyFiles = (import ./keys.nix).keyPaths;
  };
}
