{
  lib,
  pkgs,
  ...
}: {
  # Fuzzy finder and navigation
  programs.bat.enable = true; # Cat clone with syntax highlighting
  programs.fd.enable = true;
  programs.ripgrep.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
