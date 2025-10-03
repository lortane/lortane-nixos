{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;

  appBundles = {
    core = {
      modules = [
        ./keepassxc
        ./librewolf
      ];
      packages = with pkgs; [ nautilus ];
    };

    productivity = {
      modules = [ ];
      packages = with pkgs; [ kdePackages.okular ];
    };

    development = {
      modules = [ ];
      packages = with pkgs; [ uv ];
    };

    media = {
      modules = [ ];
      packages = with pkgs; [ gimp ];
    };

    gaming = {
      modules = [ ];
      packages = with pkgs; [ winetricks ];
    };
  };

  allModules = lib.concatLists (lib.attrValues (lib.mapAttrs (name: group: group.modules) appBundles));

in
{
  # Import ALL modules unconditionally, let each module decide if it should be active
  imports = allModules;

  options.desktop.appBundles = {
    core = lib.mkOption {
      type = lib.types.bool;
      default = true;
      internal = true;
      description = "Core desktop applications";
    };

    productivity = lib.mkEnableOption "productivity applications";
    development = lib.mkEnableOption "development tools";
    media = lib.mkEnableOption "media applications";
    gaming = lib.mkEnableOption "gaming applications";
  };

  config = mkIf cfg.enable {
    # Package bundles for each group - conditionally enable in config section
    home.packages = lib.concatLists [
      (lib.optionals cfg.appBundles.core appBundles.core.packages)
      (lib.optionals cfg.appBundles.productivity appBundles.productivity.packages)
      (lib.optionals cfg.appBundles.development appBundles.development.packages)
      (lib.optionals cfg.appBundles.media appBundles.media.packages)
      (lib.optionals cfg.appBundles.gaming appBundles.gaming.packages)
    ];
  };
}
