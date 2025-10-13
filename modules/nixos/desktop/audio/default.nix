{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = mkDefault true;

    wireplumber.enable = mkDefault true;
    alsa.enable = mkDefault true;
    pulse.enable = mkDefault true;
    jack.enable = mkDefault true;
    audio.enable = mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudioFull
  ];
}
