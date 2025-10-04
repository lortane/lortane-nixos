{
  config,
  lib,
  pkgs,
  spicetify-nix,
  ...
}:

let
  inherit (lib) mkIf mkDefault;

  cfg = config.desktop;
  shouldEnable = cfg.enable && cfg.appBundles.core;

  spicetifyPkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  config = mkIf shouldEnable {
    programs.spicetify = {
      enable = mkDefault true;
      enabledExtensions = with spicetifyPkgs.extensions; [
        hidePodcasts
        shuffle
      ];
      theme = spicetifyPkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
