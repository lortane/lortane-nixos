{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.desktop.starship;

  # Access Stylix colors - guaranteed to exist since Stylix is mandatory
  s = config.lib.stylix.colors.withHashtag;

  defaultSettings = {
    add_newline = false;

    format = "$directory$fill$all$character";

    directory = {
      format = "[ ](bold ${s.base0B})[ $path ]($style)";
      style = "bold ${s.base0B}";
      truncation_length = 0;
      truncate_to_repo = false;
    };

    character = {
      success_symbol = "[➜](bold ${s.base0B})";
      error_symbol = "[➜](bold ${s.base08})";
    };

    cmd_duration = {
      format = "[󰔛 $duration]($style)";
      disabled = false;
      style = "bg:none fg:${s.base0A}";
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
