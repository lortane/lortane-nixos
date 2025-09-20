{
  imports = [
    ./locale.nix
    ./packages.nix
    ./nix.nix
    ./zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;
  programs.dconf.enable = true;

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
