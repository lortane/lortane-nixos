{
  imports = [
    ./locale.nix
    ./nix.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
