{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.wayland.windowManager.hyprland;

  workspaces = import ./workspaces.nix;

  binds = builtins.concatLists [
    workspaces
  ];

  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = binds;
        bindm = (import ./mouse.nix);
      };
    };
  };
}
