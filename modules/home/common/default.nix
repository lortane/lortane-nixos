{ config, lib, ... }:

{
  imports = [
    ./cli-tools.nix
  ];


  programs.home-manager.enable = true;

  home.stateVersion = lib.mkDefault "25.05";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # JSON formatted list of Home Manager options
  manual.json.enable = true;
}