{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.keepassxc;

  inherit (lib)
    mkDefault
    mkOption
    types
    ;
in
{
  options.programs.keepassxc = {
    dbFile = mkOption {
      type = types.path;
      default = "$HOME/Passwords.kdbx";
      description = "Path to the default KeePass database (.kdbx)";
    };
  };

  config = {
    # Enable the actual Home Manager keepassxc module
    programs.keepassxc.enable = mkDefault true;
    # programs.keepassxc.autostart = mkDefault true; # needs xdg autostart enabled

    # Set GUI/browser integration defaults
    programs.keepassxc.settings = {
      Browser.Enabled = false;
      GUI = {
        ApplicationTheme = "dark";
        CompactMode = true;
      };
    };
  };
}
