{ config, lib, ... }:

let
  cfg = config.programs.starship;

  inherit (lib) mkDefault mkIf;
in
{
  programs.starship = {
    enable = mkDefault true;
    enableZshIntegration = mkDefault true;

    settings = {
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
  };
}
