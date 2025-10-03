{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;

  # Map of available WMs - import ALL unconditionally
  wmModules = {
    awesome = ./wm/awesome;
  };

  # Import ALL WM modules
  allWmImports = builtins.attrValues wmModules;
in
{
  imports = allWmImports ++ [
    ./starship
    ./apps
  ];

  options.desktop = {
    enable = mkEnableOption "desktop home configuration";

    windowManager = lib.mkOption {
      type = lib.types.enum ([ "none" ] ++ (builtins.attrNames wmModules));
      default = "awesome";
      description = "Select the window manager to configure for home";
    };

    # App groups - defined in apps.nix
    appBundles = lib.mkOption {
      type = lib.types.submodule { };
      default = { };
      description = "Desktop application groups";
    };
  };
}
