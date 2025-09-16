{
  programs.zsh = {
    enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "cursor"
        "pattern"
      ];
    };
    autosuggestions = {
      enable = true;
      strategy = [
        "completion"
        "history"
      ];
    };
    enableLsColors = true;
  };
}
