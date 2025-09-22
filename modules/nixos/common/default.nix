{
  imports = [
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./zsh.nix
  ];

  networking.firewall.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.dconf.enable = true;

  system.stateVersion = "25.05";

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
