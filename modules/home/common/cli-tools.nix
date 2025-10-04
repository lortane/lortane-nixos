{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.cli-tools.enable = lib.mkEnableOption "CLI tools environment" // {
    description = "Enable my curated collection of command-line tools";
    default = true;
  };

  imports = [ ./zsh.nix ];

  config = lib.mkIf config.cli-tools.enable {
    # Fuzzy finder and navigation
    programs.fzf.enable = true; # Fuzzy finder for files, history, etc.
    programs.zoxide.enable = true; # Smart directory jumping (smarter cd)
    programs.bat.enable = true; # Cat clone with syntax highlighting

    home.packages = with pkgs; [
      # File operations
      eza # Modern ls replacement with icons and better defaults
      ripgrep # Faster grep alternative with sane defaults
      fd # Simple and fast find replacement
      gtrash # Safe file deletion (moves to trash instead of permanent delete)

      # File management
      yazi # Terminal file manager with previews
      ncdu # Interactive disk usage analyzer

      # System utilities
      nitch # Minimal system fetch/information tool
      killall # Kill processes by name

      # Data processing
      jq # Command-line JSON processor
      bitwise # CLI tool for bit/hex manipulation and conversion
      hexdump # Display file contents in hex, decimal, octal, or ASCII
      xxd # Create hex dumps and convert back from hex

      # Network utilities
      dig # DNS lookup utility
      traceroute # Network route tracing
    ];
  };
}
