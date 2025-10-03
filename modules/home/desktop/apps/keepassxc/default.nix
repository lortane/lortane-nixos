{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkIf;
  cfg = config.desktop;
in
{
  # This app is automatically enabled for all desktop hosts
  config = mkIf (cfg.enable && cfg.apps.core) {
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
