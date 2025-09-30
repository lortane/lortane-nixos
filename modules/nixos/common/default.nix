{ pkgs, ... }:

{
  imports = [
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./zsh.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall.enable = true;
  # nixpkgs.config.allowUnfree = true;
  programs.dconf.enable = true;

  system.stateVersion = "25.05";

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
