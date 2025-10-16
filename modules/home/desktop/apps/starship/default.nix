{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.desktop.starship;

  # Access Stylix colors - guaranteed to exist since Stylix is mandatory
  colors = config.lib.stylix.colors.withHashtag;

  defaultSettings = {
    add_newline = false;

    format = "$directory$fill$all$character";

    directory = {
      format = "[ ](bold ${colors.base0B})[ $path ]($style)";
      style = "bold ${colors.base0B}";
      truncation_length = 0;
      truncate_to_repo = false;
    };

    character = {
      success_symbol = "[➜](bold ${colors.base0B})";
      error_symbol = "[➜](bold ${colors.base08})";
    };

    cmd_duration = {
      format = "[󰔛 $duration]($style)";
      disabled = false;
      style = "bg:none fg:${colors.base0A}";
      show_notifications = false;
      min_time_to_notify = 60000;
    };
  };

  # recursive merge: user settings override defaults
  mergedSettings = lib.recursiveUpdate defaultSettings (cfg.settings or {});
in {
  options.desktop.starship = {
    enable = lib.mkEnableOption "starship prompt";

    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zsh integration";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Override default starship settings";
    };
  };

  config = lib.mkIf (config.desktop.enable && cfg.enable) {
    programs.starship = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
      settings = mergedSettings;
    };
  };
}
