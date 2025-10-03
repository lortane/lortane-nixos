{ config, pkgs, ... }:

{
  # This creates an editable file
  home.file.".config/awesome".source = ./awesome;

  home.packages = with pkgs; [
    feh
    rofi
    picom
    imagemagick
    firefox
    wezterm
  ];
}
