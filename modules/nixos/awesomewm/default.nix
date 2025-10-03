{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../audio
  ];

  environment.systemPackages = [ pkgs.tuigreet ];
  security.pam.services.greetd = { };

  services = {
    xserver = {
      enable = mkDefault true;
      windowManager.awesome.enable = mkDefault true;
      displayManager = {
        lightdm.enable = false;
        startx.enable = true;
      };
    };

    greetd = {
      enable = mkDefault true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'startx ${pkgs.awesome}/bin/awesome'";
    };

  };
}
