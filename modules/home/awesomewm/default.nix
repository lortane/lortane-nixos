{ config, pkgs, ... }:

{
  # This creates an editable file
  home.file.".config/awesome/rc.lua".source = ./rc.lua;

  home.packages = with pkgs; [
    rofi
    firefox
  ];
}
