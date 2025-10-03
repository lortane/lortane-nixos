{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;
  appCfg = cfg.apps;

  appGroups = {
    # Core apps - always enabled for desktop
    core = [
      "keepassxc"
      "firefox"
    ];

    # Optional app groups
    productivity = [
      "libreoffice"
    ];

    development = [
      "vscode"
    ];

    media = [
      "vlc"
    ];

    gaming = [
      "steam"
    ];
  };
in
{
  imports = [
    ./apps/keepassxc
  ];

  options.desktop.apps = {
    core = lib.mkOption {
      type = lib.types.bool;
      default = true;
      internal = true;
      description = "Core desktop applications";
    };

    # Optional app groups
    productivity = lib.mkEnableOption "productivity applications";
    development = lib.mkEnableOption "development tools";
    media = lib.mkEnableOption "media applications";
    gaming = lib.mkEnableOption "gaming applications";
  };

  config = mkIf cfg.enable {
    # Package bundles for each group
    home.packages = lib.concatLists [
      (lib.optionals cfg.apps.core (with pkgs; [
        nautilus
      ]))
      (lib.optionals cfg.apps.productivity (with pkgs; [
        okular
      ]))
      (lib.optionals cfg.apps.development (with pkgs; [
        uv
      ]))
      (lib.optionals cfg.apps.media (with pkgs; [
        gimp
      ]))
      (lib.optionals cfg.apps.gaming (with pkgs; [
        winetricks
      ]))
    ];
  };
}
