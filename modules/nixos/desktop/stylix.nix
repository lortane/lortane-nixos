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

      base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      polarity = "dark";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.terminess-ttf;
          name = "Terminess Nerd Font";
        };

        sansSerif = {
          package = pkgs.nerd-fonts.terminess-ttf;
          name = "Terminess Nerd Font";
        };

        serif = {
          package = pkgs.nerd-fonts.terminess-ttf;
          name = "Terminess Nerd Font";
        };

        sizes = {
          terminal = 12;
          applications = 11;
        };
      };
    };
  };
}
