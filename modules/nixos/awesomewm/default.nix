{ lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  services.xserver = {
    enable = mkDefault true;
    displayManager.lightdm.enable = mkDefault true;
  };
}
