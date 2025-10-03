{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in
{
  # Make greetd launch only if graphical target is available
  systemd.services.greetd = {
    enable = true;
    unitConfig = {
      WantedBy = "graphical.target";
      After = "multi-user.target";
    };
  };

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
