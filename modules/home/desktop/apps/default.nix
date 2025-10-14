{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  cfg = config.desktop;

  appBundles = {
    core = {
      modules = [
        ./keepassxc
        ./librewolf
        ./nixvim
        ./spicetify
        ./starship
        ./wezterm
      ];
      packages = with pkgs; [
        btop
        xclip
        xsel
        libnotify # desktop notifications
        nautilus
        poweralertd # power event notifications
        tor-browser # privacy-focused browser for testing
        ungoogled-chromium # privacy-focused chrome for testing
      ];
    };

    productivity = {
      modules = [];
      packages = with pkgs; [
        drawio
        kdePackages.kleopatra # certificate manager
        kdePackages.okular
        libreoffice
        nicotine-plus # soulseek client
        protonvpn-gui # VPN client
        qalculate-gtk # calculator
      ];
    };

    development = {
      modules = [];
      packages = with pkgs; [
        gcc
        gdb
        hydra-check
        nix-init
        nurl
        sqlitebrowser
        uv
      ];
    };

    media = {
      modules = [];
      packages = with pkgs; [
        gimp
        mpv # video player
        imv # image viewer
        ffmpeg # media processing
        pamixer # audio mixing cli tool
        playerctl # media player control
      ];
    };
  };

  allModules = lib.concatLists (
    lib.attrValues (lib.mapAttrs (name: group: group.modules) appBundles)
  );
in {
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
  };

  config = mkIf cfg.enable {
    # Package bundles for each group - conditionally enable in config section
    home.packages = lib.concatLists [
      (lib.optionals cfg.appBundles.core appBundles.core.packages)
      (lib.optionals cfg.appBundles.productivity appBundles.productivity.packages)
      (lib.optionals cfg.appBundles.development appBundles.development.packages)
      (lib.optionals cfg.appBundles.media appBundles.media.packages)
    ];
  };
}
