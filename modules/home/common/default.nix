{
  config,
  lib,
  ...
}: {
  imports = [
    ./packages.nix
    ./cli-tools.nix
  ];

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # JSON formatted list of Home Manager options
  manual.json.enable = true;
}
