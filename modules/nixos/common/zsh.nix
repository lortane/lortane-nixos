{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;

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
  };
}
