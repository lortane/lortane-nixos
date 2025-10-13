{pkgs, ...}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./zsh.nix
  ];

  # Latest kernel has isues with intel gpu
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall.enable = true;
  programs.dconf.enable = true;

  system.stateVersion = "25.05";

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
