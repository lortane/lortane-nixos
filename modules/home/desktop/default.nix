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
    # Add other WMs here
  };

  # Import ALL WM modules
  allWmImports = builtins.attrValues wmModules;

in
{
  imports = allWmImports ++ [
    ./starship
    # ./apps.nix
  ];

  options.desktop = {
    enable = mkEnableOption "desktop home configuration";

    windowManager = lib.mkOption {
      type = lib.types.enum ([ "none" ] ++ (builtins.attrNames wmModules));
      default = "awesome";
      description = "Select the window manager to configure for home";
    };
  };

  config = mkIf config.desktop.enable {
    # Common home desktop configuration
    home.sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
    };

    home.packages = with pkgs; [
      file
      tree
      htop
    ];
  };
}