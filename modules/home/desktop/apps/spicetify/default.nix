{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkIf mkDefault;

  cfg = config.desktop;
  shouldEnable = cfg.enable && cfg.appBundles.core;

  spicetifyPkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = mkIf shouldEnable {
    programs.spicetify = {
      enable = mkDefault true;
      enabledExtensions = with spicetifyPkgs.extensions; [
        hidePodcasts
        shuffle
      ];
    };
  };
}
