{
  config,
  lib,
  ...
}: {
  imports = [
    ./cli-tools.nix
    ./packages.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # JSON formatted list of Home Manager options
  manual.json.enable = true;
}
