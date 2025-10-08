{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.desktop.starship;

  defaultSettings = {
    add_newline = false;

    directory = {
      format = "[ ](bold #89b4fa)[ $path ]($style)";
      style = "bold #b4befe";
      truncation_length = 0;
      truncate_to_repo = false;
    };

    character = {
      success_symbol = "[ ](bold #89b4fa)[ ➜](bold green)";
      error_symbol = "[ ](bold #89b4fa)[ ➜](bold red)";
    };

    cmd_duration = {
      format = "[󰔛 $duration]($style)";
      disabled = false;
      style = "bg:none fg:#f9e2af";
      show_notifications = false;
      min_time_to_notify = 60000;
    };
  };

  # recursive merge: user settings override defaults
  mergedSettings = lib.recursiveUpdate defaultSettings (cfg.settings or { });

in
{
  options.desktop.starship = {
    enable = lib.mkEnableOption "starship prompt";

    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zsh integration";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
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
