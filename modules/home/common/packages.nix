{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # File management
    yazi # Terminal file manager with previews
    ncdu # Interactive disk usage analyzer
    gtrash # Safe file deletion (moves to trash instead of permanent delete)

    # System utilities
    nitch # Minimal system fetch/information tool
    killall # Kill processes by name

    # Data processing
    jq # Command-line JSON processor
    bitwise # CLI tool for bit/hex manipulation and conversion
    hexdump # Display file contents in hex, decimal, octal, or ASCII
    xxd # Create hex dumps and convert back from hex
    nixfmt-rfc-style # Nix formatter

    # Network utilities
    wget
    tldr
  ];
}
