{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./fzf-open.nix
    ./hyprland.nix
    #./nextcloud-sync.nix need to setup secrets
    ./packages.nix
    #./spotify-player.nix need to setup secrets
    ./stylix.nix
    ./waybar.nix
    ./xdg.nix
    ./yazi.nix

  ];

  # FIXME: Chromium crashes the system on startup. Use Firefox for now.
  home.packages = [ pkgs.firefox ];

  dbus.packages = [
    pkgs.gnome-keyring
  ];
  home.sessionVariables = {
    GNOME_KEYRING_CONTROL = "/run/user/1000/keyring/control";
  };
}
