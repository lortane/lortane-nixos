{ lib, ... }:

{
  options = {
    cli-tools.enable = lib.mkEnableOption "My CLI environment";

    cli-tools.tools = {
      zoxide = lib.mkEnableOption "zoxide directory jumping" // {
        default = true;
      };
      fzf = lib.mkEnableOption "fzf fuzzy finding" // {
        default = true;
      };
      eza = lib.mkEnableOption "eza modern ls replacement" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.cli-tools.enable {
    programs.fzf.enable = config.cli-tools.tools.fzf;
    programs.zoxide.enable = config.cli-tools.tools.zoxide;

    home.packages = lib.mkIf config.cli-tools.tools.eza [ pkgs.eza ];

    # Import the zsh configuration that depends on these tools
    imports = [ ./zsh.nix ];
  };
}
