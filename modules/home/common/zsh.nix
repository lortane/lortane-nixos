{ lib, host, ... }:

{
  programs.zsh = {
    initContent = lib.mkBefore ''
      DISABLE_MAGIC_FUNCTIONS=true
      export "MICRO_TRUECOLOR=1"
    '';

    shellAliases = {
      # Utils
      c = "clear";
      dsize = "du -hs";
      findw = "grep -rl";
      open = "xdg-open";

      # Nixos
      ns = "nix-shell --run zsh";
      nix-shell = "nix-shell --run zsh";
      nix-switch = "sudo nixos-rebuild switch --flake ~/nixos-config#${host}";
      nix-switchu = "sudo nixos-rebuild switch --upgrade --flake ~/nixos-config#${host}";
      nix-flake-update = "sudo nix flake update ~/nixos-config#";
      nix-clean = "sudo nix-collect-garbage && sudo nix-collect-garbage -d && sudo rm /nix/var/nix/gcroots/auto/* && nix-collect-garbage && nix-collect-garbage -d";

      initExtra = ''
        # Conditional aliases based on the CLI tools module
        ${lib.optionalString config.programs.zoxide.enable ''
          alias cd="z"
        ''}

        ${lib.optionalString config.programs.eza.enable ''
          alias l="eza --icons -a --group-directories-first -1"
          alias ls="eza --icons -a --group-directories-first -1 --no-user --long"
          alias ll="eza --icons -a --group-directories-first -1 --no-user --long"
          alias tree="eza --icons --tree --group-directories-first"
        ''}

        ${lib.optionalString (!config.programs.eza.enable) ''
          alias l="ls -la"
          alias ll="ls -l"
        ''}
      '';
    };
  };
}
