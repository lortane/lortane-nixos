{
  config,
  lib,
  ...
}:

let
  cfg = config.cli-tools.enable or false;
in
{
  programs.zsh = {
    enable = true;

    initContent = lib.mkBefore ''
      DISABLE_MAGIC_FUNCTIONS=true
      export "MICRO_TRUECOLOR=1"

      ${lib.optionalString cfg ''
        alias cd="z"
        alias tt="gtrash put";

        # Modern file listing (eza)
        alias l="eza --icons -a --group-directories-first -1"
        alias ls="eza --icons -a --group-directories-first -1 --no-user --long"
        alias ll="eza --icons -a --group-directories-first -1 --no-user --long"
        alias tree="eza --icons --tree --group-directories-first"
      ''}
    '';

    shellAliases = {
      # Basic utilities
      c = "clear";
      dsize = "du -hs";
      findw = "grep -rl";

      # Nixos
      znix = "z ~/.config/lortanix";
      ns = "nix-shell --run zsh";
      nix-shell = "nix-shell --run zsh";
      nix-clean = "sudo nix-collect-garbage && sudo nix-collect-garbage -d && sudo rm /nix/var/nix/gcroots/auto/* && nix-collect-garbage && nix-collect-garbage -d";
    };
  };
}
