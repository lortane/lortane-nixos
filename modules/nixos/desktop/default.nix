{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  # Map of available WMs
  wmModules = {
    awesome = ./wm/awesome;
    i3 = ./wm/i3;
  };

  # Import ALL WM modules but conditionally enable them
  allWmImports = builtins.attrValues wmModules;
in {
  options = {
    desktop = {
      enable = mkEnableOption "desktop environment";

      windowManager = lib.mkOption {
        type = lib.types.enum (["none"] ++ (builtins.attrNames wmModules));
        default = "i3";
        description = "Select the window manager to use";
      };
    };
  };

  imports =
    [
      ./audio.nix
      ./stylix.nix
    ]
    ++ allWmImports;

  config = {
    services.libinput.enable = true;

    fonts = {
      packages = with pkgs; [
        nerd-fonts.terminess-ttf
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = ["Terminess Nerd Font"];
          sansSerif = ["Terminess Nerd Font"];
          serif = ["Terminess Nerd Font"];
        };
      };
    };
  };
}
