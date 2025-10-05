{ config, lib, ... }:

let
  inherit (lib) mkIf mkDefault;

  cfg = config.desktop;
  shouldEnable = cfg.enable && cfg.appBundles.core;
in
{
  config = mkIf shouldEnable {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ./config.lua;
    };
  };
}
