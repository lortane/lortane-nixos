{
  inputs,
  pkgs,
  nixosModules,
  extraGroups ? [],
  ...
}: {
  imports = [
    nixosModules.normal-users
    nixosModules.desktop
  ];

  normalUsers.lortane = {
    extraGroups = ["wheel"] ++ extraGroups;
    sshKeyFiles = (import ./keys.nix).keyPaths;
  };

  desktop = {
    enable = true;
    windowManager = "i3";
  };
}
