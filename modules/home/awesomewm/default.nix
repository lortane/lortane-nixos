{ config, pkgs, ... }:

let
  # Check if development config exists, otherwise use embedded
  devConfigPath = "/home/lortane/.config/awesome-dev/rc.lua";
in
{
  # This creates an editable file
  home.file.".config/awesome/rc.lua".source = config.lib.file.mkOutOfStoreSymlink devConfigPath;

  home.packages = with pkgs; [
    rofi
    firefox
  ];
}
