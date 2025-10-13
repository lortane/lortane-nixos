# modules/nixos/desktop/stylix/default.nix
{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  # Enable stylix if desktop is enabled
  config = lib.mkIf config.desktop.enable {
    stylix = {
      enable = true;

      # Default configuration
      base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      polarity = "dark";

      # Set other defaults as needed
      # image = ./default-wallpaper.jpg;
      # fonts = { ... };
    };
  };
}
