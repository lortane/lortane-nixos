{
  inputs,
  pkgs,
  nixosModules,
  extraGroups ? [],
  ...
}: {
  imports = [
    nixosModules.normal-users

    inputs.stylix.nixosModules.stylix
  ];

  normalUsers.lortane = {
    extraGroups = ["wheel"] ++ extraGroups;
    sshKeyFiles = (import ./keys.nix).keyPaths;
  };

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
}
