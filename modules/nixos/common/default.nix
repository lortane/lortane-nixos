{
  imports = [
    ./locale.nix
    ./packages.nix
    ./nix.nix
    ./zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
