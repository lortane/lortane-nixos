{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault;

  cfg = config.desktop;
  shouldEnable = cfg.enable && cfg.appBundles.core;
in {
  config = mkIf shouldEnable {
    programs.keepassxc = {
      enable = mkDefault true;

      settings = {
        Browser.Enabled = false;
        GUI = {
          ApplicationTheme = "dark";
          CompactMode = true;
        };
      };
    };

    # Optional: Set database file path if needed
    # programs.keepassxc.databaseFile = "$HOME/Passwords.kdbx";
  };
}
