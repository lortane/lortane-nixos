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
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    displayManager.defaultSession = "none+xmonad";

    greetd = {
      enable = mkDefault true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'startx ${pkgs.haskellPackages.xmonad}/bin/xmonad'";
    };

    xserver = {
      enable = true;

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      displayManager = {
        lightdm.enable = false;
        startx.enable = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };

  # TODO: laptop stuff
  # hardware.bluetooth = {
  #   enable = true;
  #   settings = {
  #     General = {
  #       Enable = "Source,Sink,Media,Socket";
  #     };
  #   };
  # };

  # services.blueman.enable = true;

  # systemd.services.upower.enable = true;

  # libinput = {
  #   enable = true;
  #   touchpad.disableWhileTyping = true;
  # };
  # upower.enable = true;
}
