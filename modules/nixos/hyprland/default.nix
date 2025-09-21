{ lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  programs.hyprland.enable = mkDefault true;
  services.udisks2.enable = mkDefault true;
}
