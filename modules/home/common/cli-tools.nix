{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    cli-tools.enable = lib.mkEnableOption "My CLI environment" // {
      description = "Enable my custom CLI environment, including fzf, zoxide, and eza.";
      default = true;
    };

    cli-tools.tools = {
      zoxide = lib.mkEnableOption "zoxide directory jumping" // {
        description = "Enable zoxide, a smart directory jumper.";
        default = true;
      };
      fzf = lib.mkEnableOption "fzf fuzzy finding" // {
        description = "Enable fzf, a command-line fuzzy finder.";
        default = true;
      };
      eza = lib.mkEnableOption "eza modern ls replacement" // {
        description = "Enable eza, a modern replacement for ls.";
        default = true;
      };
    };
  };

  imports = [ ./zsh.nix ];

  config = lib.mkIf config.cli-tools.enable {
    programs.fzf.enable = config.cli-tools.tools.fzf;
    programs.zoxide = {
      enable = config.cli-tools.tools.zoxide;
      enableZshIntegration = config.cli-tools.tools.zoxide;
    };

    home.packages = lib.mkIf config.cli-tools.tools.eza [ pkgs.eza ];
  };
}
