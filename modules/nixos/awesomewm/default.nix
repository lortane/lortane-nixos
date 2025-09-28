{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in
{
  environment.systemPackages = [ pkgs.tuigreet ];
  security.pam.services.greetd = { };

  services = {
    xserver = {
      enable = mkDefault true;
      windowManager.awesome.enable = mkDefault true;
    };

    greetd = {
      enable = mkDefault true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd awesome";
    };

  };
}
